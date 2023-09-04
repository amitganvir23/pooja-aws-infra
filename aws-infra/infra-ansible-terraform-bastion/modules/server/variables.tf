/*
   Variables for server
*/


// Generic
variable "azs" {
    default = []
}

// VPC
variable "environment" {}
variable "vpc_cidr" {}
variable "vpc_id" {}
//variable "pub_sub_id" {}
variable "subnet_id" {}
variable "associate_public_ip_address" {}
variable "ec2_count" {}

variable "public_sub_cidr" {
     default = []
}

variable "private_sub_cidr" {
     default = []
}

## Common variable for all Ec2 modules
variable "aws_key_name" {}
variable "ec2_ami" {}
variable "ec2_instance_type" {}
variable "ec2_volume_type" {}
variable "ec2_volume_size" {}