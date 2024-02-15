# Create IAM role for EC2 instance
resource "aws_iam_role" "ec2_role" {
  name = "EC2_SSM_Role${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Create an instance profile for the EC2 instance and associate the IAM role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2_SSM_Instance_Profile${var.env}"
  role = aws_iam_role.ec2_role.name
}

# This resource attaches the AmazonSSMManagedInstanceCore policy to the IAM role.
# The AmazonSSMManagedInstanceCore policy grants permissions to use the Systems Manager service.
resource "aws_iam_role_policy_attachment" "ec2_role_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# This resource attaches the AmazonEC2ContainerRegistryReadOnly policy to the IAM role.
# The AmazonEC2ContainerRegistryReadOnly policy grants permissions to pull images from ECR.
resource "aws_iam_role_policy_attachment" "ecr_read_only_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
