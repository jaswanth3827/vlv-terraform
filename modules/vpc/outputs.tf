output "vpc_id" {
    value = "${aws_vpc.aemvpc.id}"
  
}
output "public_subnet_ids" {
    value = "${aws_subnet.public.*.id}"
  
}
output "public_subnet_cidrs" {
    value = "${aws_subnet.public.*.cidr_block}"
  
}
output "private_subnet_ids" {
    value = "${aws_subnet.private.*.id}"
  
}
output "private_subnet_cidrs" {
    value = "${aws_subnet.private.*.cidr_block}"
  
}
output "internet_gateway" {
    value = "${aws_internet_gateway.igw}"
  
}













