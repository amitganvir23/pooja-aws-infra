/*
-----------------------------------------------------------------
- This deploys entire application stack
- Environment variable will control the naming convention
- Setup creds and region via env variables
- For more details: https://www.terraform.io/docs/providers/aws
-----------------------------------------------------------------
Notes:
 - control_cidr changes for different modules
 - Instance class also changes for different modules
 - Bastion should be minimum t2.medium as it would be executing config scripts
 - Default security group is added where traffic is supposed to flow between VPC
 */

/********************************************************************************/
provider "aws" {
  region = "${var.region}"
}


/****
/********************************************************************************/

#module "my-bastion" {
#   source                       = "../modules/bastion"
#   azs                          = var.azs
#   ec2_ami                      = var.ec2_ami
#   ec2_instance_type            = var.ec2_instance_type
#   aws_key_name                 = var.aws_key_name
#   vpc_cidr                     = var.vpc_cidr
#   environment                  = var.environment
#   vpc_id 	                    = var.vpc_id
#   subnet_id                    = var.subnet_id
#   associate_public_ip_address  = "true"
#   ec2_count                    = 1
#   ec2_volume_type              = var.ec2_volume_type
#   ec2_volume_size              = var.ec2_volume_size
#   os_type                      = var.os_type
#}

module "my-server" {
   source                       = "../modules/server"
   azs                          = var.azs
   ec2_ami                      = var.ec2_ami
   ec2_instance_type            = var.server_ec2_instance_type
   aws_key_name                 = var.aws_key_name
   vpc_cidr                     = var.vpc_cidr
   environment                  = var.environment
   vpc_id 	                    = var.vpc_id
   subnet_id                    = var.subnet_id
   associate_public_ip_address  = "true"
   ec2_count                    = var.server_ec2_count
   ec2_volume_type              = var.ec2_volume_type
   ec2_volume_size              = var.ec2_volume_size
   os_type                      = var.os_type
   key                          = var.key
}

module "my-node" {
   source                       = "../modules/node"
   azs                          = var.azs
   ec2_ami                      = var.ec2_ami
   ec2_instance_type            = var.node_ec2_instance_type
   aws_key_name                 = var.aws_key_name
   vpc_cidr                     = var.vpc_cidr
   environment                  = var.environment
   vpc_id 	                    = var.vpc_id
   subnet_id                    = var.subnet_id
   associate_public_ip_address  = "true"
   ec2_count                    = var.node_ec2_count
   ec2_volume_type              = var.ec2_volume_type
   ec2_volume_size              = var.ec2_volume_size
   os_type                      = var.os_type
   depends_on                   = [module.my-server]
}

module "KubernetsSetup" {
   source         = "../modules/KubernetsSetup"
   key            = var.key
   environment    = var.environment
   server_ip      = module.my-server.server_ip
   node_ips       = module.my-node.node_ips
   ec2_count      = var.node_ec2_count
   depends_on     = [module.my-server]
}
