variable "aws_region" {
  description = "AWS region used"
  type        = string
  default     = "us-east-1"
}

variable "repository_frontend_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "frontend-repository-dotnet9"
}

variable "repository_backend_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "backend-repository-dotnet9"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-demo-cluster"
}

