data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_eks_cluster_auth" "auth" {
  name = aws_eks_cluster.eks_cluster.name
}
