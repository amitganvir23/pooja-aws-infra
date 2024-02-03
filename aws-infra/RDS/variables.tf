variable "vpc_id" {
  description = "The Vpc Id to use. If not specified it will automatically be determined by using the values specified in 'environment' and 'vpc_type'."
  type        = string
  default     = ""
}

variable "subnet_ids_workers" {
  description = "List of subnets to use. If not specified then the subnets are found dynamically using the values from the following variables: 'subnets_include_cn_dtag' and 'subnets_include_private'"
  type        = list(string)
  default     = []
}

variable "db_name" {
  description = "The database name"
  type        = string
  default     = "admin"
}

variable "db_class" {
  description = "Database instance class"
  type        = string
  default     = "db.m5d.large"
}

variable "db_allocated_storage" {
  description = "The amount of storage (in gigabytes) to be initially allocated for the database instance (GB)"
  type        = number
  default     = 10
}

variable "db_max_allocated_storage" {
  description = "The upper limit to which Amazon RDS can automatically scale the storage of the DB instance (GB)"
  type        = number
  default     = 100
}

variable "db_engine_version" {
  description = "The version number of the database engine to use"
  type        = string
  default     = "8.0.32"
}

variable "db_multi_az" {
  description = "Specifies whether the database instance is a multiple Availability Zone deployment"
  type        = string
  default     = "true"
}

variable "minor_version_upgrade" {
  description = "Specifies whether minor version upgrades are enabled or not"
  type        = string
  default     = "False"
}

variable "maintenance_window" {
  description = "Timespan in which the maintenance for major or minor version updates will happen"
  type        = string
  default     = "Sun:01:00-Sun:01:30"
}

variable "backup_retention_period" {
  description = "The number of days for which automated backups are retained"
  type        = number
  default     = 30
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created"
  type        = string
  default     = "03:00-03:30"
}

variable "schedule" {
  description = "Schedule for running database instance"
  type        = string
  default     = "HELLO:no-schedule"
}


