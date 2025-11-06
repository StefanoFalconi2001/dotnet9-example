resource "aws_iam_user" "github_ci_user" {
  name = "github-ci-user"

  tags = {
    Purpose   = "CI/CD for ECR"
    ManagedBy = "Terraform"
  }
}

data "aws_iam_policy_document" "github_ci_user_policy" {
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

  statement {
    effect = "Allow"
    actions = [
      "logs:DescribeLogStreams",
      "logs:GetLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "github_ecr_policy" {
  name        = "GitHubECRPolicy"
  description = "Policy for GitHub Actions to interact with ECR"
  policy      = data.aws_iam_policy_document.github_ci_user_policy.json
}

resource "aws_iam_user_policy_attachment" "github_ci_attach" {
  user       = aws_iam_user.github_ci_user.name
  policy_arn = aws_iam_policy.github_ecr_policy.arn
}

resource "aws_iam_access_key" "github_ci_access_key" {
  user = aws_iam_user.github_ci_user.name
}


