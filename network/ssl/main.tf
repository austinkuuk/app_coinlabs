resource "aws_acm_certificate" "cert" {
  domain_name       = var.dns_name
  validation_method = var.validation_method

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = aws_acm_certificate.cert.domain_validation_options[*].resource_record_name
}
