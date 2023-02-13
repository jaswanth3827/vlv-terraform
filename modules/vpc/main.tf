#create a vpc

resource "aws_vpc" "aemvpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    "Name" = "${var.project_name}-vpc"
  }
}
#
resource "aws_subnet" "public" {
    count = "${length(var.availability_zones)}"
    vpc_id = "${aws_vpc.aemvpc.id}"
    cidr_block = "${cidrsubnet(var.cidr_block, 3, count.index)}"
    availability_zone = "${element(var.availability_zones, count.index)}"
    map_public_ip_on_launch = true
    tags= {
        "Name" = "vlv-public-subnet-${element(var.availability_zones, count.index)}"
    } 
}
resource "aws_subnet" "private" {
    count = "${length(var.availability_zones)}"
    vpc_id = "${aws_vpc.aemvpc.id}"
    cidr_block = "${cidrsubnet(var.cidr_block, 3, count.index + length(var.availability_zones))}"
    map_public_ip_on_launch = false
    tags = {
        "Name" = "vlv-private-subnet-${element(var.availability_zones, count.index)}"
    }
}
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.aemvpc.id}"
    tags = {
      "Name" = "vlv-public-route-table"
    }
  
}
resource "aws_route" "public_internet_gateway" {
    route_table_id = "${aws_route_table.public.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  
}
resource "aws_route_table_association" "public" {
    count = "${length(var.availability_zones)}"
    subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
    route_table_id = "${aws_route_table.public.id}"
  
}
resource "aws_route_table" "private" {
    count = "${length(var.availability_zones)}"
    vpc_id = "${aws_vpc.aemvpc.id}"
    tags = {
      "Name" = "vlv-private-route-table-${element(var.availability_zones, count.index)}"
    }
  
}
resource "aws_route" "nat_gateway" {
    count = "${length(var.availability_zones)}"
    route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.ngw.*.id, count.index)}"
  
}
resource "aws_route_table_association" "private" {
    count = "${length(var.availability_zones)}"
    subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
  
}
resource "aws_nat_gateway" "ngw" {
    count = "${length(var.availability_zones)}"
    subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
    allocation_id = "${element(aws_eip.elastic_ip_for_natgateway.*.id, count.index)}"
    tags = {
      "Name" = "vlv-nat-${element(var.availability_zones, count.index)}"
    }
  
}
resource "aws_eip" "elastic_ip_for_natgateway" {
    count = length(var.availability_zones)
    vpc = true
    depends_on                = [aws_internet_gateway.igw]
    tags = {
      "Name" = "vlv-eip-${element(var.availability_zones, count.index)}"
    }
  
}
resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.aemvpc.id}"
 tags = {
    "Name" = "igw-${var.project_name}-vpc"
 }
}