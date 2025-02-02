# variables.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "minimal-eks-cluster"
}

variable "ssh_key_name" {
  description = "Name of the EC2 key pair to allow SSH access to the nodes"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "jwt_secret_key" {
  description = "JWT secret key for API authentication"
  type        = string
  sensitive   = true # Marca la variable como sensible
}

variable "root_domain" {
  description = "Root domain name"
  type        = string
  default     = "encom.uy"
}

variable "api_domain" {
  description = "API subdomain name"
  type        = string
  default     = "api.encom.uy"
}

variable "route53_zone_id" {
  description = "Route53 zone ID for the API domain"
  type        = string
}
