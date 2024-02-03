output "JDBCConnectionString" {
  description = "JDBC connection string for database"
  value       = join("", ["jdbc:mysql://", aws_db_instance.rds_mysql_db.endpoint, "/", var.db_name])
}
