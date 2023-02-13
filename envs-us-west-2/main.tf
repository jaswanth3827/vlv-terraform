#create vpc
module "vpc" {
    source                          = "../modules/vpc"
    cidr_block                      = var.cidr_block
    project_name                    = var.project_name
    availability_zones              = var.availability_zones 
}
