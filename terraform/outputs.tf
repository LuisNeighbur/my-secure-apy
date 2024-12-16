# outputs.tf

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.eks_cluster.name
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_security_group.cluster.id
}

output "cluster_iam_role_name" {
  description = "IAM role name associated with EKS cluster"
  value       = aws_iam_role.eks_cluster_role.name
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN associated with EKS cluster"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "cluster_version" {
  description = "The Kubernetes version for the cluster"
  value       = aws_eks_cluster.eks_cluster.version
}

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "node_group_id" {
  description = "EKS Node Group ID"
  value       = aws_eks_node_group.node_group.id
}

output "node_group_arn" {
  description = "EKS Node Group ARN"
  value       = aws_eks_node_group.node_group.arn
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = aws_eks_node_group.node_group.status
}

output "node_group_role_name" {
  description = "IAM role name associated with EKS Node Group"
  value       = aws_iam_role.eks_node_role.name
}

output "node_group_role_arn" {
  description = "IAM role ARN associated with EKS Node Group"
  value       = aws_iam_role.eks_node_role.arn
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "nat_gateway_ips" {
  description = "List of Elastic IPs associated with NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}

output "kubectl_config_command" {
  description = "kubectl config command to connect to the cluster"
  value       = "aws eks update-kubeconfig --name ${aws_eks_cluster.eks_cluster.name} --region ${var.aws_region}"
}

output "load_balancer_hostname" {
  description = "Hostname of the application load balancer (if available)"
  value       = try(kubernetes_service.python_app_service.status.0.load_balancer.0.ingress.0.hostname, "")
}

output "cloudwatch_log_group" {
  description = "Name of CloudWatch log group for EKS cluster logs"
  value       = aws_cloudwatch_log_group.eks_cluster.name
}

output "sns_topic_arn" {
  description = "ARN of SNS topic for EKS alerts"
  value       = aws_sns_topic.eks_alerts.arn
}
