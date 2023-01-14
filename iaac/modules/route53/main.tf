resource "aws_route53_zone" "cv1" {
  name = "cv1.app"
}

resource "aws_route53_record" "cv1" {
  zone_id = aws_route53_zone.cv1.zone_id
  name    = "cv1.app"
  type    = "A"

  alias {
    name                   = var.main_alb[0].dns_name
    zone_id                = var.main_alb[0].zone_id
    evaluate_target_health = true
  }
}