# The output block exposes the IDs of the created EC2 instances as a result of this module.
output "instance_ids" {
  description = "The IDs of the created EC2 instances"
  value       = aws_instance.ec2_instance[*].id
}

output "ec2_private_key" {
  description = "The SSH private key"
  value       = "s3://${aws_s3_bucket.private_key_bucket.id}/${aws_s3_object.private_key_object.id}"
}
