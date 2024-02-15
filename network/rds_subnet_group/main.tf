# This resource block creates an AWS Database Subnet Group.
# A subnet group is a collection of subnets that can be designated for Amazon RDS when you create a DB instance.
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.name      # The name for the DB subnet group
  subnet_ids = var.subnet_ids   # List of subnet IDs to be used by the DB subnet group

  tags = var.tags   # A mapping of tags to assign to the DB subnet group
}