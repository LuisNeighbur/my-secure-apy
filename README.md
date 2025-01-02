# 🛡️ Secure API Infrastructure Project

This project implements a secure FastAPI application with dual deployment capabilities for AWS EKS and local development environments. It serves as both a production-ready infrastructure template and an educational platform for understanding security vulnerabilities and their remediation.

## 🎯 Project Purpose

The infrastructure demonstrates progressive security hardening through multiple versions, allowing developers and security professionals to understand common vulnerabilities and their solutions. Each version from 1.1.0 to 1.1.4 addresses specific security concerns while maintaining full functionality.

## 🏗️ Architecture Overview

The project supports two distinct deployment modes, each with comprehensive security features:

Production Environment (AWS):
- FastAPI application secured with JWT authentication
- EKS-based Kubernetes deployment
- SSL/TLS encryption via AWS Certificate Manager
- AWS Secrets Manager integration
- Application Load Balancer for traffic management
- Route53 DNS configuration

Local Development Environment:
- Kind-based Kubernetes cluster
- HashiCorp Vault for secrets management
- Local SSL/TLS certificates
- MetalLB for load balancing
- Development-focused security controls

## 📂 Project Structure

```
 .
├──  api
│   ├──  config.py
│   ├──  deployment.yaml
│   ├──  Dockerfile
│   ├──  main.py
│   ├──  readme.md
│   ├──  requirements.txt
│   └──  service.yaml
├──  kubernetes
│   └──  policies
├──  nginx
├──  README.md
└──  terraform
    ├──  alb.tf
    ├──  certificates.tf
    ├──  charts
    │   ├──  vault-auth
    │   │   └──  templates
    │   └──  vault-config
    │       └──  templates
    ├──  data.tf
    ├──  eks-full-policy.json
    ├──  eks-nodes-key.pem
    ├──  eks_cluster.tf
    ├──  iam.tf
    ├──  kubernetes.tf
    ├──  monitoring.tf
    ├──  node-group.tf
    ├──  outputs.tf
    ├──  providers.tf
    ├──  readme.md
    ├──  route53.tf
    ├──  secrets.tf
    ├──  security-groups.tf
    ├──  terraform.tfvars
    ├──  variables.tf
    └──  vpc.tf
```

## 🚀 Security Evolution

The application implements security improvements across five versions:

Version 1.1.0: Base Implementation
- Initial JWT authentication setup
- Basic HTTPS configuration
- Intentional vulnerabilities for educational purposes

Version 1.1.1: Initial Security Improvements
- Enhanced JWT security
- Basic secrets management
- Improved input validation

Version 1.1.2: Security Hardening
- Advanced secret management integration
- Enhanced authentication mechanisms
- Improved network security

Version 1.1.3: Infrastructure Security
- Updated base images
- Enhanced monitoring capabilities
- Additional security controls

Version 1.1.4: Production Ready
- Complete security hardening
- Comprehensive monitoring
- Production-grade configurations

## ⚙️ Prerequisites

Production Deployment:
- AWS CLI with configured credentials
- Terraform ≥ 1.0.0
- Docker
- kubectl
- Python 3.9+

Local Development:
- Docker Engine 20.10+
- Kind
- kubectl
- Python 3.9+

## 🚀 Deployment Instructions

### AWS Deployment

1. Build and push the container:
```bash
cd api
docker build -t your-repo/secure-api:latest .
docker push your-repo/secure-api:latest
```

2. Configure infrastructure:
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Update variables as needed
```

3. Deploy:
```bash
terraform init
terraform apply
```

4. Configure kubectl:
```bash
aws eks update-kubeconfig --name minimal-eks-cluster --region us-east-1
```

### Local Development

1. Start Kind cluster:
```bash
kind create cluster --config kind-config.yaml
```

2. Deploy local infrastructure:
```bash
cd terraform
terraform init
terraform apply -var-file=local.tfvars
```

## 🔐 Security Features

The project implements comprehensive security measures:

Core Security:
- HTTPS-only communication
- JWT authentication
- Secrets management integration
- Network isolation
- Security group controls
- SSL/TLS encryption

Monitoring and Alerts:
- CloudWatch integration (AWS)
- Health monitoring
- Performance tracking

## 🌐 Service Access

Production Endpoints:
- API Gateway: https://api.yourdomain.com
- Monitoring: CloudWatch dashboards
- Logs: CloudWatch logs

Local Development:
- API: http://localhost:8000

## ⚠️ Security Advisory

This project contains intentional security vulnerabilities for educational purposes. Each version demonstrates specific security concepts and their remediation. Version 1.1.4 represents the fully secured implementation suitable for production use.

## 🤝 Contributing

We welcome contributions that enhance both the educational value and security implementations:

1. Fork the repository
2. Create a feature branch
3. Implement changes with documentation
4. Submit detailed pull request
5. Participate in code review

## 📄 License

This project is licensed under the MIT License. See LICENSE file for details.

---

Note: This project is designed for security education and vulnerability scanning practice with Trivy. For production deployments, use only version 1.1.4 with appropriate security configurations.