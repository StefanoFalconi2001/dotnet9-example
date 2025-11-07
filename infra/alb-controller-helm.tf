resource "helm_release" "aws_load_balancer_controller" {
  depends_on = [
    aws_eks_cluster.demo_cluster,
    aws_iam_policy.alb_controller_policy
  ]

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set = [
    {
      name  = "clusterName"
      value = aws_eks_cluster.demo_cluster.name
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "region"
      value = var.aws_region
    },
    {
      name  = "vpcId"
      value = aws_vpc.eks_vpc.id
    }
  ]
}
