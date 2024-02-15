# This resource block creates an AWS security group.
# A security group acts as a virtual firewall for your instance to control inbound and outbound traffic.
resource "aws_security_group" "allow_all" {
  name        = var.sg_name    # The name of the security group
  description = var.sg_description   # The description of the security group
  vpc_id      = var.vpc_id     # The VPC ID where the security group will be created

  # The ingress block allows all inbound traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # The egress block allows all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags   # A map of tags to add to the security group
}
