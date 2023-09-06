resource "null_resource" "call_ansible" {
  provisioner "local-exec" {
    command = "${path.module}/k8s-join.sh"
    interpreter = ["bash"]
    environment = {
      key = var.key
      env = var.environment
    }
  }
}