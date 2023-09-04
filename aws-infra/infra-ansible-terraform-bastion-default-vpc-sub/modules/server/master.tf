resource "aws_instance" "server" {
    ami                         = "${var.ec2_ami}"
    instance_type               = "${var.ec2_instance_type}"
    key_name                    = "${var.aws_key_name}"
    vpc_security_group_ids      = ["${aws_security_group.server-sg.id}"]
    #count                      = "${length(var.public_sub_cidr)}"
    count                       = var.ec2_count
    #user_data                  = "${data.template_file.userdata-server.rendered}"
    user_data = <<EOF
        #!/bin/bash
        sudo yum update -y
        echo 'LC_CTYPE=en_US.UTF-8' >> /etc/environment
        sudo amazon-linux-extras install ansible2 -y
        sudo hostnamectl set-hostname server${count.index+1}
        sudo yum install docker -y
        sudo systemctl start docker
        sudo systemctl enable docker
        EOF
    subnet_id                   = "${var.subnet_id}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    source_dest_check           = false
    // Implicit dependency
    //iam_instance_profile        = "${aws_iam_instance_profile.server_profile.name}"
    root_block_device {
      volume_type = var.ec2_volume_type
      volume_size = var.ec2_volume_size
      delete_on_termination = true
      //delete_on_termination = false
        }
      volume_tags = {
                Name = "vol-server-${count.index+1}"
                }

    tags = {
      Name        = "server-${count.index+1}"
      Role        = "server"
      Environment = "${var.environment}"
      Stack       = "Supporting-mongo"
    }

}
