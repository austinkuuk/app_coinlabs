# Output variables are like the return values of a Terraform module. 
# The rds_endpoint is the hostname and port that applications should use to access the DB instance.
output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.rds_instance.endpoint
}

# The db_user outputs the username for the RDS instance. 
output "db_user" {
  description = "The username for the RDS instance"
  value       = aws_db_instance.rds_instance.username
}

# The db_password outputs the password for the RDS instance. 
output "db_password" {
  description = "The password for the RDS instance"
  value       = aws_db_instance.rds_instance.password
  sensitive   = true
}

output "db_name" {
  description = "The database name for the RDS instance"
  value       = aws_db_instance.rds_instance.db_name
}