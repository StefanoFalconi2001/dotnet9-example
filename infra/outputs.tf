output "repository_backend_url" {
  description = "URL of the created ECR repository"
  value       = aws_ecr_repository.backend_repository
}

output "repository_frontend_url" {
  description = "URL of the created ECR repository"
  value       = aws_ecr_repository.frontend_repository
}

output "github_ci_access_key_id" {
  description = "Access Key ID for the GitHub CI user"
  value       = aws_iam_access_key.github_ci_access_key.id
}

output "github_secret_access_key" {
  description = "Secret Access Key for the GitHub CI user"
  value       = aws_iam_access_key.github_ci_access_key.secret
  sensitive   = true
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = aws_eks_cluster.demo_cluster.endpoint
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.demo_cluster.name
}
