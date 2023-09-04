/*
   Variables for bastion
*/


// Generic
variable "azs" {
    default = []
}

// VPC
variable "environment" {}
variable "vpc_cidr" {}
variable "associate_public_ip_address" {}
variable "ec2_count" {}

// Defualt Values
variable "vpc_id" {}
variable "subnet_id" {}

variable "public_sub_cidr" {
     default = []
}

variable "private_sub_cidr" {
     default = []
}

## Common variable for all Ec2 modules
variable "ec2_ami" {}
variable "ec2_instance_type" {}
variable "aws_key_name" {}
variable "ec2_volume_type" {}
variable "ec2_volume_size" {}