resource "aws_ecr_repository" "repository" {
  name  = var.ecr_repo
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "repository_lifecycle_policy" {
  repository       = aws_ecr_repository.repository.name
  policy = file("${path.module}/lifecycle_policy.json")
}
