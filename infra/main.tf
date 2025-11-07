terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
}

# 🔹 Data sources para obtener información del cluster EKS
data "aws_eks_cluster" "eks" {
  name = aws_eks_cluster.demo_cluster.name
}

data "aws_eks_cluster_auth" "eks" {
  name = aws_eks_cluster.demo_cluster.name
}

# 🔹 Provider Helm (usa los datos del cluster EKS)
provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}
