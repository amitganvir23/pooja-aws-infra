resource "time_sleep" "wait_120_seconds_to_k8s_join" {
  create_duration = "2m"
}

resource "null_resource" "k8s_join" {
  triggers = {
    always_run  = "${timestamp()}"
  }

  provisioner "local-exec" {
    command     = "${path.module}/k8s-join.sh"
    interpreter = ["bash"]
    environment = {
      key       = var.key
      env       = var.environment
      server_ip = var.server_ip
      node_ips  = var.node_ips
      ec2_count = var.ec2_count
    }
  }
}
