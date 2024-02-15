variable "dns_name" {
  description = "The fully qualified domain name for the certificate"
  type        = string
}

variable "validation_method" {
  description = "Which method to use for validation, DNS or EMAIL"
  default     = "DNS"
}
