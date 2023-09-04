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
ec2_ami              = "ami-05fa00d4c63e32376"
ec2_instance_type    = "t2.micro"
aws_key_name         = "mac"
ec2_volume_type      = "gp2"
ec2_volume_size      = "8"

