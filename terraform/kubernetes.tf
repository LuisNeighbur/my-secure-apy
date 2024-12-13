# kubernetes.tf
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
          image = "docker.io/luisneighbur/my-secure-api:v1.1.4"
          name  = "my-secure-api"

          port {
            container_port = 5000
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
              path = "/" # Cambiado de /health a /
              port = 5000
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            failure_threshold     = 3
            timeout_seconds       = 5
          }

          readiness_probe {
            http_get {
              path = "/" # Cambiado de /health a /
              port = 5000
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            failure_threshold     = 3
            timeout_seconds       = 5
          }

          # Añadiendo variables de entorno si son necesarias
          env {
            name  = "PORT"
            value = "5000"
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
    labels = {
      app = "my-secure-api"
    }
  }

  spec {
    selector = {
      app = "my-secure-api"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }

  depends_on = [
    kubernetes_deployment.python_app
  ]
}
