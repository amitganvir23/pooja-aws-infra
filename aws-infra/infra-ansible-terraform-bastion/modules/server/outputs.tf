output "server-sg" {
   value = "${aws_security_group.server-sg.id}"
}


/*
output "server_id" {
   value = "${aws_instance.server.id}"
}
*/