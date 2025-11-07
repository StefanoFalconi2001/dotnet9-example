resource "aws_iam_policy" "alb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "Permissions for AWS Load Balancer Controller"
  policy      = file("aws-load-balancer-controller-policy.json")
}

resource "aws_iam_user_policy_attachment" "attach_alb_policy" {
  user       = "github-ci-user"
  policy_arn = aws_iam_policy.alb_controller_policy.arn
}
