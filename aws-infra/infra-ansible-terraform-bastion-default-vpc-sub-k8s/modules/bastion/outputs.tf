output "bastion-sg" {
   value = "${aws_security_group.bastion-sg.id}"
}


/*
output "bastion_id" {
   value = "${aws_instance.bastion.id}"
}
*/