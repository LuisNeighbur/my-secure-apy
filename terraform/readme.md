# EKS Terraform Infrastructure 🚀

Este proyecto contiene la infraestructura como código para desplegar un cluster EKS en AWS usando Terraform.

## 📋 Tabla de Contenidos

- [Requisitos Previos](#requisitos-previos)
- [Permisos Necesarios](#permisos-necesarios)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Configuración Inicial](#configuración-inicial)
- [Despliegue](#despliegue)
- [Tiempo Estimado de Despliegue](#tiempo-estimado-de-despliegue)
- [Monitoreo del Despliegue](#monitoreo-del-despliegue)
- [Acceso al Cluster](#acceso-al-cluster)
- [Limpieza](#limpieza)
- [Notas Importantes](#notas-importantes)
- [Solución de Problemas](#solución-de-problemas)
- [Contribuir](#contribuir)
- [Licencia](#licencia)

## 🛠️ Requisitos Previos

* AWS CLI configurado
* Terraform >= 1.0.0
* kubectl
* Una cuenta AWS con permisos suficientes

## 🔑 Permisos Necesarios

Se requiere una política IAM con los siguientes permisos:

<details>
<summary>Ver política IAM completa</summary>

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*",
                "ec2:AllocateAddress",
                "ec2:AssociateRouteTable",
                "ec2:AttachInternetGateway",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateInternetGateway",
                "ec2:CreateKeyPair",
                "ec2:CreateNatGateway",
                "ec2:CreateRoute",
                "ec2:CreateRouteTable",
                "ec2:CreateSecurityGroup",
                "ec2:CreateSubnet",
                "ec2:CreateTags",
                "ec2:CreateVpc",
                "ec2:DeleteInternetGateway",
                "ec2:DeleteKeyPair",
                "ec2:DeleteNatGateway",
                "ec2:DeleteRoute",
                "ec2:DeleteRouteTable",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteSubnet",
                "ec2:DeleteTags",
                "ec2:DeleteVpc",
                "ec2:DescribeAddresses",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInstances",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeNatGateways",
                "ec2:DescribeNetworkInterfaces",
                "ec2:DescribeRouteTables",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "ec2:DetachInternetGateway",
                "ec2:DisassociateRouteTable",
                "ec2:ImportKeyPair",
                "ec2:ModifyVpcAttribute",
                "ec2:ReleaseAddress",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
                "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
                "iam:AddRoleToInstanceProfile",
                "iam:AttachRolePolicy",
                "iam:CreateInstanceProfile",
                "iam:CreatePolicy",
                "iam:CreateRole",
                "iam:DeleteInstanceProfile",
                "iam:DeletePolicy",
                "iam:DeleteRole",
                "iam:DeleteRolePolicy",
                "iam:DetachRolePolicy",
                "iam:GetInstanceProfile",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:ListAttachedRolePolicies",
                "iam:ListInstanceProfilesForRole",
                "iam:ListRolePolicies",
                "iam:PassRole",
                "iam:PutRolePolicy",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:TagRole",
                "iam:UntagRole",
                "iam:UpdateAssumeRolePolicy",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DeleteLogGroup",
                "logs:DeleteLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "sns:CreateTopic",
                "sns:DeleteTopic",
                "sns:GetTopicAttributes",
                "sns:ListSubscriptionsByTopic",
                "sns:ListTopics",
                "sns:Subscribe",
                "sns:Unsubscribe",
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:DeleteAlarms",
                "cloudwatch:DescribeAlarms",
                "autoscaling:CreateAutoScalingGroup",
                "autoscaling:DeleteAutoScalingGroup",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:UpdateAutoScalingGroup",
                "elasticloadbalancing:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:CreateGrant",
                "kms:CreateKey",
                "kms:DeleteKey",
                "kms:DescribeKey",
                "kms:GetKeyPolicy",
                "kms:ListGrants",
                "kms:ListKeyPolicies",
                "kms:ListKeys",
                "kms:PutKeyPolicy",
                "kms:RevokeGrant",
                "kms:ScheduleKeyDeletion"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:CreateBucket",
                "s3:DeleteBucket",
                "s3:GetBucketLocation",
                "s3:GetBucketPolicy",
                "s3:ListBucket",
                "s3:PutBucketPolicy",
                "s3:PutEncryptionConfiguration"
            ],
            "Resource": "*"
        }
    ]
}
```
</details>

## 📁 Estructura del Proyecto

```
.
├── README.md
├── providers.tf          # Configuración de providers AWS y Kubernetes
├── variables.tf         # Definición de variables
├── vpc.tf              # Configuración de VPC y networking
├── security-groups.tf   # Grupos de seguridad
├── iam.tf              # Roles y políticas IAM
├── eks-cluster.tf      # Configuración del cluster EKS
├── node-group.tf       # Configuración de los grupos de nodos
├── monitoring.tf       # CloudWatch y SNS
├── kubernetes.tf       # Deployments y servicios K8s
├── data.tf            # Data sources
└── outputs.tf         # Outputs del despliegue
```

## 🚀 Configuración Inicial

1. **Crear un key pair para los nodos:**
   ```bash
   aws ec2 create-key-pair --key-name eks-nodes-key --query 'KeyMaterial' --output text > eks-nodes-key.pem
   chmod 400 eks-nodes-key.pem
   ```

2. **Crear el archivo `terraform.tfvars`:**
   ```hcl
   aws_region   = "us-east-1"
   cluster_name = "minimal-eks-cluster"
   ssh_key_name = "eks-nodes-key"
   environment  = "production"
   ```

## 📦 Despliegue

1. **Inicializar Terraform:**
   ```bash
   terraform init
   ```

2. **Revisar el plan:**
   ```bash
   terraform plan
   ```

3. **Aplicar la configuración:**
   ```bash
   terraform apply
   ```

## ⏱️ Tiempo Estimado de Despliegue

| Componente | Tiempo Aproximado |
|------------|------------------|
| VPC y Red | 2-3 minutos |
| EKS Control Plane | 10-12 minutos |
| Node Group | 5-7 minutos |
| Aplicación | 2-5 minutos |
| **Total** | **15-25 minutos** |

## 📊 Monitoreo del Despliegue

```bash
# Estado del cluster
aws eks describe-cluster --name minimal-eks-cluster --query 'cluster.status'

# Estado del node group
aws eks describe-nodegroup \
    --cluster-name minimal-eks-cluster \
    --nodegroup-name minimal-eks-cluster-node-group \
    --query 'nodegroup.status'

# Verificar pods
kubectl get pods -w

# Verificar servicio
kubectl get svc -w
```

## 🔐 Acceso al Cluster

**Configurar kubectl:**
```bash
aws eks update-kubeconfig --name minimal-eks-cluster --region us-east-1
```

## 🧹 Limpieza

**Eliminar todos los recursos:**
```bash
terraform destroy
```

## 📝 Notas Importantes

* El cluster se despliega con nodos en subnets privadas
* Se crea un NAT Gateway para permitir que los nodos accedan a Internet
* Se implementa CloudWatch logging para el cluster
* Se configura un SNS topic para alertas
* Se despliega un LoadBalancer para acceder a la aplicación

## 🔧 Solución de Problemas

### Error "KeyPair not found"

1. **Verificar key pair existente:**
   ```bash
   aws ec2 describe-key-pairs
   ```

2. **Crear nuevo key pair si no existe:**
   ```bash
   aws ec2 create-key-pair --key-name eks-nodes-key \
       --query 'KeyMaterial' --output text > eks-nodes-key.pem
   ```

## 🤝 Contribuir

1. Fork el repositorio
2. Cree una rama para su característica (`git checkout -b feature/AmazingFeature`)
3. Commit sus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abra un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT.