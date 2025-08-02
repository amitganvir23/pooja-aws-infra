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

module "my-vpc" {
   source                   = "../modules/vpc"
   azs                      = "${var.azs}"
   vpc_cidr                 = "${var.vpc_cidr}"
   public_sub_cidr          = "${var.public_sub_cidr}"
   private_sub_cidr         = "${var.private_sub_cidr}"
   enable_dns_hostnames     = true
   vpc_name                 = "${var.vpc_name}-${var.environment}"
   environment              = "${var.environment}"
}

module "my-bastion" {
   source                       = "../modules/bastion"
   azs                          = "${var.azs}"
   ec2_ami                      = "${var.ec2_ami}"
   ec2_instance_type            = "${var.ec2_instance_type}"
   aws_key_name                 = "${var.aws_key_name}"
   vpc_cidr                     = "${var.vpc_cidr}"
   environment                  = "${var.environment}"
   vpc_id 	                    = "${module.my-vpc.vpc_id}"
   subnet_id                    = element(module.my-vpc.public_subnet_id[0], 2)
 //subnet_id                    = "${module.my-vpc.public_subnet_id}"
   associate_public_ip_address  = "true"
   ec2_count                    = 1
   ec2_volume_type              = var.ec2_volume_type
   ec2_volume_size              = var.ec2_volume_size
}


module "my-server" {
   source                       = "../modules/server"
   azs                          = "${var.azs}"
   ec2_ami                      = "${var.ec2_ami}"
   ec2_instance_type            = "${var.ec2_instance_type}"
   aws_key_name                 = "${var.aws_key_name}"
   vpc_cidr                     = "${var.vpc_cidr}"
   environment                  = "${var.environment}"
   vpc_id 	                = "${module.my-vpc.vpc_id}"
   subnet_id                    = element(module.my-vpc.private_subnet_id[0], 2)
   associate_public_ip_address  = "false"
   ec2_count                    = 1
   ec2_volume_type              = var.ec2_volume_type
   ec2_volume_size              = var.ec2_volume_size
}

module "my-node" {
   source                       = "../modules/node"
   azs                          = "${var.azs}"
   ec2_ami                      = "${var.ec2_ami}"
   ec2_instance_type            = "${var.ec2_instance_type}"
   aws_key_name                 = "${var.aws_key_name}"
   vpc_cidr                     = "${var.vpc_cidr}"
   environment                  = "${var.environment}"
   vpc_id 	                    = "${module.my-vpc.vpc_id}"
   subnet_id                    = element(module.my-vpc.private_subnet_id[0], 2)
   associate_public_ip_address  = "false"
   ec2_count                    = 1
   ec2_volume_type              = var.ec2_volume_type
   ec2_volume_size              = var.ec2_volume_size
}

