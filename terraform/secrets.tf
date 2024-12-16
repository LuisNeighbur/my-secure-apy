# secrets.tf
resource "aws_secretsmanager_secret" "api_secret" {
  name                    = "my-super-jwt-secret-api-key"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "api_secret" {
  secret_id = aws_secretsmanager_secret.api_secret.id
  secret_string = jsonencode({
    jwt_secret_key = var.jwt_secret_key
  })
}
