output "certificate_arn" {
  description = "ARN of the validated certificate"
  value       = aws_acm_certificate_validation.cert_validation.certificate_arn
}
