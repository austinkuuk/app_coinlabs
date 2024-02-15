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
