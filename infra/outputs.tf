###########################
# 📦 ECR Repositories
###########################
output "frontend_ecr_repository_url" {
  description = "ECR URL for the frontend image"
  value       = aws_ecr_repository.frontend_repository.repository_url
}

output "backend_ecr_repository_url" {
  description = "ECR URL for the backend image"
  value       = aws_ecr_repository.backend_repository.repository_url
}

###########################
# ☸️ EKS Cluster
###########################
output "eks_cluster_name" {
  description = "EKS Cluster name"
  value       = aws_eks_cluster.demo_cluster.name
}

output "eks_cluster_endpoint" {
  description = "EKS Cluster API endpoint"
  value       = aws_eks_cluster.demo_cluster.endpoint
}

output "eks_cluster_oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider"
  value       = aws_iam_openid_connect_provider.eks.arn
}

###########################
# 🔐 IAM Roles
###########################
output "alb_controller_role_arn" {
  description = "ARN of the IAM Role for AWS Load Balancer Controller"
  value       = aws_iam_role.alb_controller.arn
}

output "github_actions_role_arn" {
  description = "ARN of the IAM Role used by GitHub Actions via OIDC"
  value       = aws_iam_role.github_actions_ecr.arn
}

###########################
# 🌍 Useful Info
###########################
output "vpc_id" {
  description = "VPC used by the EKS cluster"
  value       = aws_vpc.eks_vpc.id
}

output "region" {
  description = "AWS Region"
  value       = var.aws_region
}
