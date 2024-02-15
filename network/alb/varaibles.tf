variable "public_subnet_ids" {
  description = "List of IDs of public subnets"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group to associate with the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be created"
  type        = string
}

variable "port" {
  description = "Port for ALB and Target Port"
  type        = number
  default     = 80
}

variable "instance_ids" {
  description = "List of IDs of EC2 instances to attach to the target group"
  type        = list(string)
}

variable "certificate_arn" {
  description = "The ARN of the SSL certificate"
  type        = string
}

variable "env" {
  type = string
  description = "The Env variabale"
}