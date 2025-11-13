resource "aws_kms_key" "ecr" {
  description              = "KMS key for ECR encryption"
  deletion_window_in_days  = 7
  enable_key_rotation      = true
  tags = { Environment = var.environment }
}

resource "aws_ecr_repository" "main" {
  name                  = var.repository_name
  image_tag_mutability  = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.ecr.arn
  }
  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_ecr_repository_policy" "main" {
  repository = aws_ecr_repository.main.name
  policy     = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPull"
        Effect    = "Allow"
        Principal = { AWS = var.allowed_account_arns }
        Action    = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
      }
    ]
  })
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name
  policy     = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 prod images"
        selection = {
          tagStatus      = "tagged"
          tagPrefixList  = ["prod"]
          countType      = "imageCountMoreThan"
          countNumber    = 30
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Remove untagged images after 7 days"
        selection = {
          tagStatus    = "untagged"
          countType    = "sinceImagePushed"
          countUnit    = "days"
          countNumber  = 7
        }
        action = { type = "expire" }
      }
    ]
  })
}

output "repository_url" {
  value = aws_ecr_repository.main.repository_url
}
