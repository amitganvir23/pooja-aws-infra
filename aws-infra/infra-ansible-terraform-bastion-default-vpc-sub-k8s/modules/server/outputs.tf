output "server-sg" {
   value = "${aws_security_group.server-sg.id}"
}

output "server_ip" {
   value = "${aws_instance.server[0].public_ip}"
}

/*
output "server_id" {
   value = "${aws_instance.server.id}"
}
*/