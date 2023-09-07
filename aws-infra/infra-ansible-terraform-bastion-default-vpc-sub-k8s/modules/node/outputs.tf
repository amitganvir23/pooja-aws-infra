output "node-sg" {
   value = "${aws_security_group.node-sg.id}"
}

output "node_ips" {
#   value = "${aws_instance.node[*].public_ip}"
   value = "${join(" ",aws_instance.node.*.public_ip)}"
}

/*
output "node_id" {
   value = "${aws_instance.node.id}"
}
*/