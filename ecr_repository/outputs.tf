output "repository_url" {
  description = "The URL of the created repositories."
  value       = aws_ecr_repository.repository.repository_url
}
