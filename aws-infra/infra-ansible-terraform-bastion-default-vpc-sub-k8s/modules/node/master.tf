resource "aws_instance" "node" {
    ami                         = var.ec2_ami
    instance_type               = var.ec2_instance_type
    key_name                    = var.aws_key_name
    vpc_security_group_ids      = ["${aws_security_group.node-sg.id}"]
    #count                      = "${length(var.public_sub_cidr)}"
    count                       = var.ec2_count
    #user_data                  = "${data.template_file.userdata-node.rendered}"
    user_data                   = "${file("${path.module}/${var.os_type}-user-data-init.sh")}"
    subnet_id                   = "${var.subnet_id}"
    associate_public_ip_address = "${var.associate_public_ip_address}"
    source_dest_check           = false
    //iam_instance_profile        = "${aws_iam_instance_profile.node_profile.name}"
    root_block_device {
      volume_type = var.ec2_volume_type
      volume_size = var.ec2_volume_size
      delete_on_termination = true
      //delete_on_termination = false
        }
      volume_tags = {
                Name = "vol-node-${count.index+1}-${var.environment}"
                }
    tags = {
      Name        = "node-${count.index+1}-${var.environment}"
      Role        = "${var.environment}-node"
      Environment = var.environment
      Stack       = "Supporting-mongo"
    }

}
