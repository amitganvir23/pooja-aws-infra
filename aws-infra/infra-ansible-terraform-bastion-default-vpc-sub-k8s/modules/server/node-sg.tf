/*
- server-sg
- All traffic in vpc is open since we do not know what all ports we may
  have to open
 */
resource "aws_security_group" "server-sg" {
   name = "server-sg"
   vpc_id = "${var.vpc_id}"

   // allows traffic from the SG itself for tcp
   ingress {
       from_port = 0
       to_port = 65535
       protocol = "tcp"
       self = true
   }

   // allows traffic from the SG itself for udp
   ingress {
       from_port = 0
       to_port = 65535
       protocol = "udp"
       self = true
   }

   ingress {
      from_port = 0
      to_port = 65535
      protocol = "udp"
      cidr_blocks = ["${var.vpc_cidr}"]
   }

   ingress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["${var.vpc_cidr}"]
   }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["115.110.209.228/32"]
    description = "MY office Network IP"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["115.110.209.228/32"]
    description = "MY office Network IP"
  }

  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["103.208.69.15/32"]
      description = "MY Home IP"
    }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH for Everyone"
  }

   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
   }
}
