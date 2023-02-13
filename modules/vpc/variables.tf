variable "availability_zones" {
    description = "availability zones"
    type = list(string)
  
}
variable "project_name" {
    description = "name of the project"
    type = string
  
}
variable "cidr_block" {
    description = "cidr range of vpc to partition the subnets"
    type = string
}