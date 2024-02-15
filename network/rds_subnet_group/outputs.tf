output "name" {
  description = "The name of the DB Subnet Group"
  value       = aws_db_subnet_group.rds_subnet_group.name
}