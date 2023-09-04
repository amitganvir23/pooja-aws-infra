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
ec2_ami              = "ami-053b0d53c279acc90"
ec2_instance_type    = "t2.micro"
aws_key_name         = "mac2"
ec2_volume_type      = "gp2"
ec2_volume_size      = "8"

## userdata variable
os_type  = "ubuntu"
#os_type  = "rhel"
#os_type  = "amazon"

## K8s Master
server_ec2_instance_type = "t2.medium"
server_ec2_count           = "1"

## K8s Worker/Node
node_ec2_instance_type   = "t2.micro"
node_ec2_count           = "2"

