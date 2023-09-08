## K8s Join
variable "key" {}
variable "environment" {}
variable "node_ec2_count" {}

## output
variable "server_ip" {}
variable "node_ips" {
  default = []
}

