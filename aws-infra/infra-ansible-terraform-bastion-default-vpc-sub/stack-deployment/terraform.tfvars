/*
 Variables for deploying stack
--------------------------------
- ACM certificates have to pre-exist
*/

// General
region            = "us-east-1"
//azs             = ["us-east-1a","us-east-1b"]
azs               = ["us-east-1a"]
vpc_id            = "vpc-07cab67d"
subnet_id         = "subnet-4c694a2b"
vpc_cidr          = "172.31.0.0/16"
environment       = "test"
vpc_name          = "amit-vpc"

/* Classes of instances - has to change based on environment
- Please choose between the following only
- [dev|qa|stage]
*/


## Common values for all Ec2 modules
ec2_ami              = "ami-020cba7c55df1f615" # ubuntu 24.04
#ec2_ami              = "ami-053b0d53c279acc90"
ec2_instance_type    = "t3.micro"
aws_key_name         = "newmac"
ec2_volume_type      = "gp3"
ec2_volume_size      = "8"

