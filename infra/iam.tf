resource "aws_iam_user" "github_ci_user" {
  name = "github-ci-user"

  tags = {
    Purpose   = "CI/CD for ECR + ALB"
    ManagedBy = "Terraform"
  }
}

data "aws_iam_policy_document" "github_ci_ecr_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:CreateRepository",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = [
      aws_ecr_repository.frontend_repository.arn,
      aws_ecr_repository.backend_repository.arn
    ]
  }
}

resource "aws_iam_policy" "github_ecr_policy" {
  name        = "GitHubECRPolicy"
  description = "Policy for GitHub Actions to interact with ECR"
  policy      = data.aws_iam_policy_document.github_ci_ecr_policy.json
}

data "aws_iam_policy_document" "github_ci_ec2_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeAddresses",
      "ec2:DescribeInstances",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribeTags"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "github_ec2_policy" {
  name        = "GitHubEC2Policy"
  description = "Policy for GitHub Actions to interact with EC2 (needed by ALB Controller)"
  policy      = data.aws_iam_policy_document.github_ci_ec2_policy.json
}

resource "aws_iam_user_policy_attachment" "github_ci_attach_ecr" {
  user       = aws_iam_user.github_ci_user.name
  policy_arn = aws_iam_policy.github_ecr_policy.arn
}

resource "aws_iam_user_policy_attachment" "github_ci_attach_ec2" {
  user       = aws_iam_user.github_ci_user.name
  policy_arn = aws_iam_policy.github_ec2_policy.arn
}

resource "aws_iam_access_key" "github_ci_access_key" {
  user = aws_iam_user.github_ci_user.name
}


