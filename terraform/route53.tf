data "aws_route53_zone" "main" {
  name = var.root_domain
}

# Root domain A record pointing to ALB
resource "aws_route53_record" "root" {
  zone_id = data.aws_route53_zone.main.zone_id # Changed from resource to data source
  name    = var.root_domain
  type    = "A"

  alias {
    name                   = aws_lb.api_alb.dns_name
    zone_id                = aws_lb.api_alb.zone_id
    evaluate_target_health = true
  }
}

# API subdomain A record pointing to ALB
resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.main.zone_id # Changed from resource to data source
  name    = var.api_domain
  type    = "A"

  alias {
    name                   = aws_lb.api_alb.dns_name
    zone_id                = aws_lb.api_alb.zone_id
    evaluate_target_health = true
  }
}
