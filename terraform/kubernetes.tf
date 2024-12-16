# kubernetes.tf
resource "kubernetes_deployment" "python_app" {
  metadata {
    name      = "my-secure-api"
    namespace = "default"
    labels = {
      app = "my-secure-api"
    }
  }

  wait_for_rollout = true
  spec {
    replicas = 2

    strategy {
      type = "RollingUpdate"
      rolling_update {
        max_surge       = 1
        max_unavailable = 0
      }
    }

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
        node_selector = {
          "kubernetes.io/os" = "linux"
        }
        container {
          image             = "docker.io/luisneighbur/my-secure-api:v1.1.4"
          name              = "my-secure-api"
          image_pull_policy = "Always"

          port {
            container_port = 8000
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          # Modificando los health checks para usar la ruta principal
          # o la ruta que sepas que existe en tu API
          liveness_probe {
            http_get {
              path = "/health" # Cambiado de /health a /
              port = 8000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            failure_threshold     = 3
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/health" # Cambiado de /health a /
              port = 8000
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            failure_threshold     = 3
            timeout_seconds       = 5
          }

          # Añadiendo variables de entorno si son necesarias
          env {
            name  = "PORT"
            value = "8000"
          }
          env {
            name  = "SECRET_NAME"
            value = aws_secretsmanager_secret.api_secret.name
          }

          env {
            name  = "AWS_DEFAULT_REGION"
            value = var.aws_region
          }

          # Añadir environment para identificar el entorno
          env {
            name  = "ENVIRONMENT"
            value = var.environment
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
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type"             = "alb"
      "service.beta.kubernetes.io/aws-load-balancer-scheme"           = "internet-facing"
      "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"         = aws_acm_certificate.api_cert.arn
      "service.beta.kubernetes.io/aws-load-balancer-ssl-ports"        = "443"
      "service.beta.kubernetes.io/aws-load-balancer-backend-protocol" = "http"
      "external-dns.alpha.kubernetes.io/hostname"                     = "${var.api_domain}, ${var.root_domain}"
    }
  }

  spec {
    selector = {
      app = "my-secure-api"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 8000
      protocol    = "TCP"
    }

    port {
      name        = "https"
      port        = 443
      target_port = 8000
      protocol    = "TCP"
    }


    type = "LoadBalancer"
  }
}
