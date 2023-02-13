variable "region" {
    description = "The aws region where infrastructure to be launched "
}
variable "project_name" {
    description = "The name of the project"
}
variable "cidr_block" {
    description = "cidr range for the vpc"
}
variable "availability_zones" {
    type = string
    description = "availability zones in the region"
}
