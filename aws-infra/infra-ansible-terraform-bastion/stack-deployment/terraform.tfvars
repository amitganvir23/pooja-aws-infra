/*
 Variables for deploying stack
--------------------------------
- ACM certificates have to pre-exist
*/

// General
region            = "us-east-1"
//azs             = ["us-east-1a","us-east-1b"]
azs               = ["us-east-1a"]
vpc_name          = "amit-vpc"
vpc_cidr          = "192.168.0.0/26"
//vpc_cidr        = "172.168.0.0/16"
environment       = "dev"

/* Classes of instances - has to change based on environment
- Please choose between the following only
- [dev|qa|stage]
*/

# AZs are combintation of az length + subnet cidrs
public_sub_cidr   = ["192.168.0.0/28","192.168.0.16/28"]
private_sub_cidr  = ["192.168.0.32/28","192.168.0.48/28"]

//public_sub_cidr   = ["172.168.0.0/24","172.168.1.0/24"]
//private_sub_cidr  = ["172.168.3.0/24","172.168.4.0/24"]


## Common values for all Ec2 modules
ec2_ami              = "ami-053b0d53c279acc90"
ec2_instance_type    = "t2.micro"
aws_key_name         = "mac2"
ec2_volume_type      = "gp2"
ec2_volume_size      = "8"

