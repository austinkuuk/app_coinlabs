# Defines a variable to hold the name of the DB subnet group
variable "name" {
  description = "The name for the DB subnet group"
  type        = string
}

# Defines a variable to hold the list of subnet IDs for the DB subnet group
variable "subnet_ids" {
  description = "List of subnet IDs to be used by the DB subnet group"
  type        = list(string)
}

# Defines a variable to hold the tags for the DB subnet group
variable "tags" {
  description = "A mapping of tags to assign to the DB subnet group"
  type        = map(string)
  default     = {}
}
