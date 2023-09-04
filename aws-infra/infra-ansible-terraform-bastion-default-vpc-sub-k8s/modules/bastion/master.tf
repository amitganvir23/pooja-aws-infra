resource "aws_instance" "bastion" {
    ami                         = "${var.ec2_ami}"
    instance_type               = "${var.ec2_instance_type}"
    key_name                    = "${var.aws_key_name}"
    vpc_security_group_ids      = ["${aws_security_group.bastion-sg.id}"]
    count                       = var.ec2_count
#    user_data                  = "${data.template_file.userdata-bastion.rendered}"
    user_data                   = "${file("${path.module}/${var.os_type}-user-data-init.sh")}"
#    user_data                   = "${file("${path.module}/user-data-init.sh")}"
  #    user_data = <<EOF
#        #!/bin/bash
#        sudo apt-get update -y
#        EOF
    subnet_id                   = "${var.subnet_id}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    source_dest_check           = false
    // Implicit dependency
    //iam_instance_profile        = "${aws_iam_instance_profile.bastion_profile.name}"
    root_block_device {
      volume_type = var.ec2_volume_type
      volume_size = var.ec2_volume_size
      delete_on_termination = true
      //delete_on_termination = false
        }
      volume_tags = {
                      Name = "vol-bastion-${count.index+1}-${var.environment}"
                    }
    tags = {
      Name        = "bastion-${count.index+1}-${var.environment}"
      Role        = "${var.environment}-bastion"
      Environment = var.environment
      Stack       = "Supporting-mongo"
    }

}
