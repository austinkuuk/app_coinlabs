# The allocated_storage variable determines the amount of storage space to assign to the RDS instance. This is measured in gigabytes.
variable "allocated_storage" {
  description = "The amount of storage to allocate to the RDS instance"
}

# The engine variable specifies the database engine to use for the RDS instance. Typical values might include "mysql", "postgres", "mssql", etc.
variable "engine" {
  description = "The database engine to use"
}

# The engine_version variable determines the version of the database engine to use. This allows you to control the exact version of the database software.
variable "engine_version" {
  description = "The version of the database engine to use"
}

# The instance_class variable is used to determine the compute and memory capacity of the Amazon RDS instance.
variable "instance_class" {
  description = "The instance type to use for the RDS instance"
}

# The name variable sets the name of the RDS instance. This is how you will refer to your instance within AWS.
variable "name" {
  description = "The name of the RDS instance"
}

# The username variable is used to set the username for the MySQL database. It is used for authentication when connecting to the database.
variable "username" {
  description = "Username for the MySQL database"
}

# The password variable is used to set the password for the MySQL database. It is used for authentication when connecting to the database.
variable "password" {
  description = "Password for the MySQL database"
  sensitive   = true
}

# The parameter_group_name variable is used to specify the name of the parameter group. Parameter groups provide a way to manage database engine configuration through a set of parameters.
variable "parameter_group_name" {
  description = "The name of the parameter group to associate with the RDS instance"
}

# The publicly_accessible variable is a boolean flag that determines whether the RDS instance is publicly accessible or not. 
# If set to false, both the instance and the database it contains are not accessible directly from the internet.
variable "publicly_accessible" {
  description = "Whether the RDS instance is publicly accessible or not"
}

# The subnet_group_name variable is used to specify the subnet group for the RDS instance. 
# The subnet group is a collection of subnets (typically private) that you can designate for your DB instances in a VPC.
variable "subnet_group_name" {
  description = "The name of the subnet group for the RDS instance"
}

# The vpc_security_group_ids variable is a list of security group IDs to associate with the RDS instance.
# Security groups act as virtual firewalls that control the traffic to your instance.
variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the RDS instance"
  type        = list(string)
}