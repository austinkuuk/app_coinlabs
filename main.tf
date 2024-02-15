# Configure the backend to use AWS S3. The backend is responsible for storing the
# current state of your  infrastructure. By using S3, we can share state between
# multiple users, which is essential for teams working on the same infrastructure.
terraform {
  # backend "s3" {
  #   key            = "tf-wp/terraform.tfstate" # The path in the bucket where Terraform will store the state file for this set of resources.
  #   bucket         = "zeta-s3-state" # The name of the S3 bucket where Terraform will store its state files.
  #   region         = "ap-northeast-1"  # The AWS region where the S3 bucket is located. 
  #   encrypt        = true # This option forces Terraform to encrypt the state data stored in S3.
  #   dynamodb_table = "zeta-state-lock" # The name of a DynamoDB table for state locking and consistency checking.
  # }

  #  Specify the required providers and their versions. In this case, we are using the AWS provider.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.48"
    }
  }
}

# This block configures the AWS provider, which is responsible for creating and managing AWS resources.
provider "aws" {
  region = var.region # The AWS region where to create the resources.
}

# This module creates a VPC (Virtual Private Cloud) which is a virtual network dedicated to your AWS account.
module "vpc" {
  source = "./network/vpc" # The path to the module's source code

  name            = var.name
  cidr            = var.cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

# This module creates a security group within the VPC. A security group acts as a virtual firewall for your instance to control inbound and outbound traffic.
module "security_group" {
  source         = "./network/security_groups"              # The path to the module's source code.
  sg_name        = "allow_all_sg"                           # The name of the security group.
  sg_description = "Security group that allows all traffic" # A description of the security group.
  vpc_id         = module.vpc.vpc_id                        # The ID of the VPC where to create the security group.
  tags           = { Name = "AllowAllSecurityGroup" }       # Metadata to assign to the security group.
}

# This module creates an EC2 instance (a virtual server) in AWS.
module "ec2_instance" {
  source                 = "./ec2_instance"                          # The path to the module's source code.
  ami_id                 = var.ami_id                                # The ID of the Amazon Machine Image (AMI) to use for the instance.
  instance_type          = var.instance_type                         # The type of instance to start.
  instance_name          = var.instance_name                         # The name of the instance.
  number_of_instances    = var.number_of_instances                   # The number of instances to start.
  subnet_id              = module.vpc.private_subnet_ids[0]          # The ID of the subnet to launch the instance into.
  db_username            = var.db_username                           # The username of the MySQL database.
  db_password            = var.db_password                           # The password of the MySQL database.
  vpc_security_group_ids = [module.security_group.security_group_id] # The associated security groups in non-default VPC.
  db_host                = module.rds_instance.rds_endpoint          # The hostname of the RDS instance.
  iam_instance_profile   = module.iam_roles.instance_profile.name
  env                    = var.env
  db_name                = var.db_name
  docker_image           = var.docker_image
}

module "ssl" {
  source            = "./network/ssl"
  dns_name          = var.dns_name
  validation_method = var.validation_method
}

# This module creates an ALB and Target Group for the EC2 instances.
module "alb" {
  source            = "./network/alb"
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_group.security_group_id
  vpc_id            = module.vpc.vpc_id
  instance_ids      = module.ec2_instance.instance_ids
  certificate_arn   = module.ssl.certificate_arn
  env               = var.env
}

# This module creates a subnet group for the RDS instance. A subnet group is a collection of subnets that you can designate for your DB instances in a DB instance.
module "rds_subnet_group" {
  source     = "./network/rds_subnet_group"  # The path to the module's source code.
  name       = var.rds_subnet_group_name     # The name for the DB subnet group.
  subnet_ids = module.vpc.private_subnet_ids # The ID of the subnets to associate with the DB instance.
  tags = {
    Name = "My RDS Subnet Group" # Metadata to assign to the DB subnet group.
  }
}

# This module creates an RDS instance. Amazon RDS makes it easy to set up, operate, and scale a relational database in the cloud.
module "rds_instance" {
  source                 = "./rds_instance"                          # The path to the module's source code.
  allocated_storage      = 20                                        # The amount of storage (in gibibytes) to allocate for the DB instance.
  engine                 = "mysql"                                   # The name of the database engine to be used for the RDS instance.
  engine_version         = "8.0.33"                                  # The version number of the database engine to use.
  instance_class         = "db.t2.micro"                             # The compute and memory capacity of the DB instance.
  name                   = var.db_name                               # The name of the DB instance.
  username               = var.db_username                           # The username for the master DB user.
  password               = var.db_password                           # The password for the master DB user.
  parameter_group_name   = "default.mysql8.0"                        # The name of the DB parameter group to associate with this DB instance.
  subnet_group_name      = module.rds_subnet_group.name              # The name of the DB subnet group to use for the DB instance.
  vpc_security_group_ids = [module.security_group.security_group_id] # The associated security groups in non-default VPC.
  publicly_accessible    = false                                     # Whether the DB instance is publicly accessible or not.
}

# This module creates an IAM role and instance profile for the EC2 instances.
module "iam_roles" {
  source = "./iam_roles"
  env    = var.env
}

module "ecr_repository" {
  source           = "./ecr_repository"
  ecr_repo = var.ecr_repo
  count = (terraform.workspace == "ECR") ? 1 : 0
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "instance_ids" {
  description = "The IDs of the created EC2 instances"
  value       = module.ec2_instance.instance_ids
}

output "repository_urls" {
  description = "The URLs of the created repositories."
  value       = module.ecr_repository[*].repository_url
}

output "ec2_private_key" {
  description = "The SSH private key"
  value       = module.ec2_instance.ec2_private_key
}
