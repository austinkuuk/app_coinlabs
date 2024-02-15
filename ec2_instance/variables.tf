# AMI ID is used to specify the Amazon Machine Image that will be used when launching EC2 instances. 
# Each AMI is a machine template from which you can instantiate new servers.
variable "ami_id" {}

# This variable is used to specify the type of EC2 instance to be created. 
# The instance type determines the hardware of the host computer (e.g., its CPU, memory, storage, and network capacity).
variable "instance_type" {}

# The variable is used to assign a name to the EC2 instance. This name is used for identification purposes within AWS.
variable "instance_name" {}

# This variable is used to specify the number of EC2 instances to create. 
# It is used when you want to create multiple instances of the same configuration.
variable "number_of_instances" {}

# This variable sets the username for the database. It is used for authentication when connecting to the database.
variable "db_username" {
  validation {
    condition     = length(var.db_username) > 0
    error_message = "The db_username must not be empty."
  }
}

# This variable sets the password for the database. It is used for authentication when connecting to the database.
variable "db_password" {
  validation {
    condition     = length(var.db_password) > 0
    error_message = "The db_password must not be empty."
  }
}

# This variable sets the database host, which is the endpoint where the database is located.
variable "db_host" {
  validation {
    condition     = length(var.db_host) > 0
    error_message = "The db_host must not be empty."
  }
}

variable "db_name" {
  validation {
    condition     = length(var.db_name) > 0
    error_message = "The db_name must not be empty."
  }
}

# This list variable is used to set the security group IDs associated with the EC2 instances. 
# Security groups act as a virtual firewall for your instance to control inbound and outbound traffic.
variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the EC2 instances"
  type        = list(string)
}

# This variable is used to specify the subnet ID where the EC2 instances will be launched. 
# Subnets enable you to partition your network within the VPC.
variable "subnet_id" {
  description = "The ID of the subnet where the EC2 instances will be launched"
  type        = string
}

variable "iam_instance_profile" {
  description = "The name of the IAM instance profile to associate with the EC2 instances."
  type        = string
}

variable "env" {
  type        = string
}

variable "docker_image" {
  type        = string
}
