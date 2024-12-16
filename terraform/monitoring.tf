resource "aws_cloudwatch_log_group" "eks_cluster" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7

  tags = {
    Name        = "${var.cluster_name}-logs"
    Environment = var.environment
  }
}

resource "aws_sns_topic" "eks_alerts" {
  name = "${var.cluster_name}-alerts"

  tags = {
    Name        = "${var.cluster_name}-alerts"
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "eks_alerts_email" {
  topic_arn = aws_sns_topic.eks_alerts.arn
  protocol  = "email"
  endpoint  = "luisneighbur@gmail.com"
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "${var.cluster_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EKS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors EKS CPU utilization"

  dimensions = {
    ClusterName = aws_eks_cluster.eks_cluster.name
    NodeGroup   = aws_eks_node_group.node_group.node_group_name
  }

  alarm_actions = [aws_sns_topic.eks_alerts.arn]
}
