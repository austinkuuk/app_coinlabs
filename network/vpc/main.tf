# This module block creates an AWS VPC (Virtual Private Cloud).
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true   # Whether to create a NAT gateway
  single_nat_gateway = true   # Whether to create a single NAT gateway
  one_nat_gateway_per_az = false   # Whether to create one NAT gateway per availability zone

  enable_vpn_gateway = false   # Whether to create a VPN gateway

  tags = {
    Name = "terraform-wordpress-vpc"   # Name tag for the VPC
    Terraform = "true"   # Tag indicating that this VPC was created with Terraform
    Environment = "dev"   # Environment tag for the VPC
  }
}
