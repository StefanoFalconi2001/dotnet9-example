resource "aws_ecr_repository" "frontend_repository" {
  name                 = var.repository_frontend_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    environment = "dev"
    project     = "dotnet9-frontend"
  }
}

resource "aws_ecr_repository" "backend_repository" {
  name                 = var.repository_backend_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    environment = "dev"
    project     = "dotnet9-backend"
  }
}
