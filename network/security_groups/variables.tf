# Defines a variable to hold the name of the security group
variable "sg_name" {
  description = "The name of the security group"
  type        = string
}

# Defines a variable to hold the description of the security group
variable "sg_description" {
  description = "The description of the security group"
  type        = string
}

# Defines a variable to hold the VPC ID where the security group will be created
variable "vpc_id" {
  description = "The VPC ID where the security group will be created"
  type        = string
}

# Defines a variable to hold the tags for the security group
variable "tags" {
  description = "A map of tags to add to the security group"
  type        = map(string)
  default     = {}
}
