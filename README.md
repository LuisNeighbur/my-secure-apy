# Secure API Infrastructure Project

This project consists of a secure FastAPI application deployed on AWS EKS with SSL/TLS encryption, JWT authentication, and AWS Secrets Manager integration.

## Architecture Overview

- **API**: FastAPI application with JWT authentication
- **Infrastructure**: AWS EKS with Terraform
- **Security**: SSL/TLS, AWS Secrets Manager
- **Load Balancing**: AWS Application Load Balancer
- **DNS**: Route53 with SSL certificate

## Project Structure

```
.
├── app/                    # FastAPI application
│   ├── main.py            # Main application file
│   ├── config.py          # Configuration and AWS integration
│   ├── requirements.txt   # Python dependencies
│   └── Dockerfile         # Container configuration
│
├── terraform/             # Infrastructure as Code
│   ├── alb.tf            # Load Balancer configuration
│   ├── certificates.tf    # SSL/TLS certificates
│   ├── eks-cluster.tf    # EKS cluster configuration
│   ├── iam.tf            # IAM roles and policies
│   ├── kubernetes.tf      # Kubernetes resources
│   ├── monitoring.tf     # CloudWatch configuration
│   ├── node-group.tf     # EKS node group
│   ├── providers.tf      # AWS and Kubernetes providers
│   ├── route53.tf        # DNS configuration
│   ├── secrets.tf        # AWS Secrets Manager
│   ├── security-groups.tf # Security groups
│   ├── variables.tf      # Terraform variables
│   └── vpc.tf            # Network configuration
```

## Prerequisites

- AWS CLI configured
- Terraform ≥ 1.0.0
- Docker
- kubectl
- Python 3.9+

## Quick Start

1. **Build and Push the Docker Image**
```bash
cd app
docker build -t your-repo/secure-api:latest .
docker push your-repo/secure-api:latest
```

2. **Configure Infrastructure**
```bash
cd terraform
# Create terraform.tfvars
cp terraform.tfvars.example terraform.tfvars
# Edit with your values
```

3. **Deploy Infrastructure**
```bash
terraform init
terraform apply
```

4. **Configure kubectl**
```bash
aws eks update-kubeconfig --name minimal-eks-cluster --region us-east-1
```

## Environment Variables

Create a `terraform.tfvars` file with:
```hcl
aws_region   = "us-east-1"
cluster_name = "minimal-eks-cluster"
root_domain  = "yourdomain.com"
api_domain   = "api.yourdomain.com"
environment  = "production"
```

## Security Features

- HTTPS only (port 443)
- JWT authentication
- AWS Secrets Manager for sensitive data
- Private subnets for EKS nodes
- Security groups with minimal permissions
- ACM certificates for SSL/TLS

## API Endpoints

- `GET /health`: Health check endpoint
- `POST /token`: JWT token generation
- `GET /users/me`: Current user information
- `GET /products`: List of products (protected)
- `GET /products/{id}`: Specific product (protected)

## Monitoring

- CloudWatch logs for EKS cluster
- CloudWatch alarms for CPU utilization
- SNS notifications for alarms

## Estimated Deployment Time

- EKS Cluster: ~15 minutes
- Load Balancer: ~5-7 minutes
- Certificate Validation: ~5-10 minutes
- Total: ~30 minutes

## Common Issues

1. **503 Service Unavailable**
   - Check target group health
   - Verify security group rules
   - Check pod logs

2. **Certificate Issues**
   - Ensure DNS propagation
   - Verify ACM certificate validation

3. **Authentication Issues**
   - Check Secrets Manager configuration
   - Verify JWT secret key

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.