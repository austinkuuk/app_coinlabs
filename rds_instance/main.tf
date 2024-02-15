# This block creates the RDS instance with the specified configuration. 
resource "aws_db_instance" "rds_instance" {
  allocated_storage    = var.allocated_storage
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  db_name              = var.name
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  publicly_accessible  = var.publicly_accessible
  skip_final_snapshot = true

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.subnet_group_name

  tags = {
    Name = "app_coinlans_dev"
  }
}