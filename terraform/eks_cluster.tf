provider "aws" {
  profile = "dev01"
  region  = "us-east-1"
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = "minimal-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_logging_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy_attachment" "eks_cloudwatch_container_insights" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.31.0.0/24" # Subnet 1
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.31.1.0/24" # Subnet 2
  availability_zone = "us-east-1b"
}

resource "aws_vpc" "main" {
  cidr_block = "172.31.0.0/20"
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "minimal-eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  instance_types = ["t3.micro"] # You can use the minimal instance type such as t3.micro
  ami_type       = "AL2_x86_64" # Amazon Linux 2 AMI
  tags = {
    Name = "minimal-eks-node-group"
  }
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_ec2_container_registry_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Declare the eks_cluster_auth data source
data "aws_eks_cluster_auth" "auth" {
  name = aws_eks_cluster.eks_cluster.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
}

# resource "kubernetes_config_map" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = yamlencode({
#       "rolearn"  = aws_iam_role.eks_node_role.arn
#       "username" = "system:node:{{EC2PrivateDNSName}}"
#       "groups" = [
#         "system:bootstrappers",
#         "system:nodes"
#       ]
#     })
#     mapRoles2 = yamlencode({
#       "rolearn"  = aws_iam_role.eks_cluster_role.arn
#       "username" = "eks-cluster-role"
#       "groups" = [
#         "system:masters"
#       ]
#     })
#     mapUsers = yamlencode([
#       {
#         "userarn"  = "arn:aws:iam::353142293520:user/dev01"
#         "username" = "dev01"
#         "groups" = [
#           "system:masters"
#         ]
#       }
#     ])
#   }

#   lifecycle {
#     ignore_changes = [data]
#   }
# }

resource "aws_sns_topic" "sns_topic" {
  name = "my-secure-sns-topic"
}

resource "aws_sns_topic_subscription" "sns_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "email"
  endpoint  = "luisneighbur@gmail.com" # Replace with your email address
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "HighCPUUsage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EKS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm triggers when CPU utilization is over 80% for 5 minutes"
  dimensions = {
    ClusterName = aws_eks_cluster.eks_cluster.name
    Nodegroup   = aws_eks_node_group.node_group.node_group_name
  }

  alarm_actions = [aws_sns_topic.sns_topic.arn]
}



resource "kubernetes_deployment" "python_app" {
  metadata {
    name      = "my-secure-api"
    namespace = "default"
    labels = {
      app = "my-secure-api"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "my-secure-api"
      }
    }
    template {
      metadata {
        labels = {
          app = "my-secure-api"
        }
      }
      spec {
        container {
          image = "docker.io/luisneighbur/my-secure-api:v1.1.0"
          name  = "my-secure-api"
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "python_app_service" {
  metadata {
    name      = "my-secure-api-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "my-secure-api"
    }

    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}
