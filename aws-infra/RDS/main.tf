provider "aws" {
  region     = "us-west-1"
}

terraform {
  required_version = ">= 0.14.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.35"
    }
#    kubernetes = {
#      source  = "hashicorp/kubernetes"
#      version = ">= 2.0.0"
#    }
  }
#  backend "s3" {}
}


#########################
# ----- RDS MySQL ----- #
#########################

resource "aws_security_group" "DBSecurityGroup" {
  name_prefix = "SG_RDS_mysql"
  description = "Access to RDS mysql from application security group"
  vpc_id      = var.vpc_id

  ingress {
#    security_groups          = data.aws_security_groups.rds_sg.ids
    protocol                 = "tcp"
    from_port                = 3306
    to_port                  = 3306
    description              = "mysql database port reachable only from application security group"
  }

  tags = {
    "hello:sec:InfoSecClass" = "Internal"
    "hello:sec:NetworkLayer" = "Database"
  }
}

resource "aws_db_parameter_group" "ParameterGroup" {
  name        = "myfirstparametergroup"
  description = "secure parameters for RDS with mysql"
  family      = "mysql8.0"

  parameter {
    name  = "local_infile"
    value = "0"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "general_log"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "tls_version"
    value = "TLSv1.2"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "skip_show_database"
    value = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "safe-user-create"
    value = "1"
    apply_method = "pending-reboot"
  }

  tags = {
    Name = "${var.db_name}-ParameterGroupInstance"
    apply_method = "pending-reboot"
  }
}

resource "aws_db_subnet_group" "DBSubnetGroup" {
  name        = "db-private-subnet"
  description = "DB Private Subnet"
#  subnet_ids  = var.subnet_ids_hello
  subnet_ids  = ["subnet-d504108e", "subnet-1ed12978"]
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "SecretsManagerSecret" {
  name       = var.db_name
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "SecretsManagerSecret" {
  secret_id     = aws_secretsmanager_secret.SecretsManagerSecret.id
  secret_string = <<EOF
   {
    "username": "masteruser",
    "password": "${random_password.password.result}"
   }
EOF
}

resource "aws_db_instance" "rds_mysql_db" {
  allocated_storage       = var.db_allocated_storage
#  ca_cert_identifier      = "rds-ca-ecc384-g1"
  engine                  = "mysql"
  engine_version          = var.db_engine_version
  instance_class          = var.db_class
  identifier              = var.db_name
  name                    = var.db_name
  username                = local.db_creds.username
  password                = local.db_creds.password
  storage_type            = "gp2"
  multi_az                = var.db_multi_az
  backup_retention_period = var.backup_retention_period
  backup_window           = var.preferred_backup_window
  maintenance_window      = var.maintenance_window
  storage_encrypted       = true
  vpc_security_group_ids  = [aws_security_group.DBSecurityGroup.id]
  db_subnet_group_name    = aws_db_subnet_group.DBSubnetGroup.name
  skip_final_snapshot     = true
  tags = {
    "hello:sec:InfoSecClass" = "Internal"
    "hello:sec:NetworkLayer" = "Database"
    "Schedule"              = var.schedule
  }
}

data "aws_secretsmanager_secret" "secretRDS" {
  arn = aws_secretsmanager_secret.SecretsManagerSecret.arn
}

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.secretRDS.arn
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
}

#resource "aws_db_event_subscription" "rds_mysql_db_event_subscription" {
#  name             = "rds-mysql-db-event-subscription"
#  enabled          = true
#  sns_topic        = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.this.account_id}:HELLO_general"
#  source_ids       = [aws_db_instance.rds_mysql_db.identifier]
#  source_type      = "db-instance"
#  event_categories = ["maintenance"]
#}
##------------------------------------------------------------
