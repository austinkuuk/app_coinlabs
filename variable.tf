# Variable representing the AWS region where resources will be provisioned. 
# This allows you to select the appropriate region based on your requirements such as latency, cost, etc.
# Default is set to "ap-northeast-1" .
variable "region" {
  description = "Identifier for the AWS region to create resources in"
  default     = "ap-northeast-2"
}

# Variable used to assign a name to the EC2 instance(s) created. 
# This helps in easily identifying your instances in the AWS console. 
# Default is set to "awsbuilder-demo".
variable "instance_name" {
  description = "Name to be assigned to the created EC2 instance(s)"
  default     = "coinlabs-app"
}

# Variable to specify the type of EC2 instance(s) to be created.
# Instance types comprise of varying combinations of CPU, memory, storage, and networking capacity. 
# Choose an instance type based on the amount of resources your workload requires.
# Default is set to "t2.micro".
variable "instance_type" {
  description = "Type of EC2 instance to create"
  default     = "t3.large"
}

# Variable representing the Amazon Machine Image (AMI) ID for the EC2 instance(s).
# AMIs are the templates that contain the software configurations (operating system, application server, and applications) needed to launch your instances.
# You should provide an AMI that is suitable for your application environment. Default is set to "ami-08508144e576d5b64".
variable "ami_id" {
  description = "AMI ID to use for the EC2 instances"
  default     = "ami-0f3a440bbcff3d043"
}

# Variable representing the number of instances to be created.
# It allows you to create multiple instances at once. 
# This can be useful in scenarios where you want to deploy multiple instances for load balancing or redundancy. 
# Default is set to 1.
variable "number_of_instances" {
  description = "Number of instances to create"
  default     = 1
}

# Variable for setting the username for the MySQL database.
# It's important for security that you don't use default or easily guessed usernames.
variable "db_username" {
  description = "Username for the MySQL database"
}

# Variable for setting the password for the MySQL database.
# Be sure to use a strong password for your databases. 
# Terraform will handle this value as a sensitive value and will therefore obfuscate it in the console output.
variable "db_password" {
  description = "Password for the MySQL database"
  sensitive   = true
}

variable "db_name" {
  description = "The name of the MySQL database for Wordpress"
  default = "coinlabs_app"
}

variable "ecr_repo" {
  description = "The name of the ECR repo."
  type        = string
  default     = "docker_wordpress"
}

variable "dns_name" {
  description = "The fully qualified domain name for the certificate"
  type        = string
}

variable "validation_method" {
  description = "Which method to use for validation, DNS or EMAIL"
  default     = "DNS"
}

variable "name" {
  type = string
  description = "The name of the VPC"
}

variable "cidr" {
  type = string
  description = "The CIDR block for the VPC"
}

variable "azs" {
  type = list(string)
  description = "List of availability zones in the region"
}

variable "private_subnets" {
  type = list(string)
  description = "List of private subnet CIDR blocks"
}

variable "public_subnets" {
  type = list(string)
  description = "List of public subnet CIDR blocks"
}

variable "rds_subnet_group_name" {
    type = string
  description = "The Name of Subnet Group"
}

variable "env" {
  type = string
  description = "The Env variabale"
}

variable "docker_image" {
  type = string
  default = ""
  description = "The custom wordpress docker image to use (full image, with tag and registry like '123456789.dkr.ecr.ap-northeast-1.amazonaws.com/docker_wordpress:v1.0.1-a652k83'). Leave empty to use the public wordpress image from dockerhub."
}
