resource "aws_instance" "bastion" {
    ami                         = "${var.ec2_ami}"
    instance_type               = "${var.ec2_instance_type}"
    key_name                    = "${var.aws_key_name}"
    vpc_security_group_ids      = ["${aws_security_group.bastion-sg.id}"]
    count                       = var.ec2_count
    #user_data                  = "${data.template_file.userdata-bastion.rendered}"
    #user_data                   = "${file("user-data-common.sh")}"
    user_data = <<EOF
        #!/bin/bash
        sudo yum update -y
        sudo amazon-linux-extras install ansible2 -y
        echo 'LC_CTYPE=en_US.UTF-8' >> /etc/environment
        sudo hostnamectl set-hostname bastion${count.index+1}
        sudo yum install docker -y
        sudo systemctl start docker
        sudo systemctl enable docker
        export username=pooja
        adduser $username
        echo $username | passwd $username --stdin
        cp -ra /home/ec2-user/.ssh /home/$username/
        chown $username:$username -R /home/$username/.ssh
        echo "$username    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
        EOF
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
                      Name = "vol-bastion-${count.index+1}"
                    }
    tags = {
      Name        = "bastion-${count.index+1}"
      Role        = "bastion"
      Environment = "${var.environment}"
      Stack       = "Supporting-mongo"
    }

}
