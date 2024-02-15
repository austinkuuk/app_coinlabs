# This resource block generates a new RSA key that will be used to connect to the EC2 instances securely.
resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
}

# This resource block creates a new AWS key pair that will be used to authenticate with the instances.
resource "aws_key_pair" "generated_key" {
  key_name   = "ec2_key${var.env}"
  public_key = tls_private_key.tls_key.public_key_openssh
}

resource "aws_s3_bucket" "private_key_bucket" {
  bucket_prefix = "tf-wp-key"
  force_destroy = true
}

resource "aws_s3_object" "private_key_object" {
  bucket  = aws_s3_bucket.private_key_bucket.id
  key     = "coinlab_app_${var.env}_id_rsa.pem"
  content = tls_private_key.tls_key.private_key_pem

  tags = {
    Name = "coinlabs_app_s3_${var.env}_key"
  }
}

# This resource block creates the actual EC2 instances based on the specified variables and resources.
resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  count         = var.number_of_instances
  instance_type = var.instance_type
  key_name      = aws_key_pair.generated_key.key_name

  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id              = var.subnet_id
  associate_public_ip_address = true

  iam_instance_profile = var.iam_instance_profile

  # User data is used to specify actions to take upon launching the instances.
  user_data = base64encode("${templatefile("${path.module}/userdata_simple.sh", {
    docker_image = var.docker_image
    db_host      = var.db_host
    db_name      = var.db_name
    db_username  = var.db_username
    db_password  = var.db_password
  })}")

  # Each instance is tagged with a unique name for identification.
  tags = {
    Name = "${var.instance_name}-${var.env}"
  }
}
