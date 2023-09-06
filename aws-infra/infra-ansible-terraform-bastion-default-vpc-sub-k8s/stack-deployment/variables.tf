/*
   Variables for all modules
*/


// Generic
variable "azs" {
    default = []
}

// VPC
variable "region" {}
variable "environment" {}
variable "vpc_id" {}
variable "vpc_cidr" {}
variable "vpc_name" {}

// Defualt Values
variable "subnet_id" {}

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

## userdata variable
variable "os_type" {}

## K8s Master
variable "server_ec2_instance_type" {}
variable "server_ec2_count" {}

## K8s Worker/Node
variable "node_ec2_instance_type" {}
variable "node_ec2_count" {}

## K8s Join
variable "key" {}