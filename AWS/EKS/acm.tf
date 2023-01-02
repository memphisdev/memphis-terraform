/// ACM Certificate for Memphis UI HTTPS/SSL
resource "aws_acm_certificate" "cert" {
  count =  var.enable_ssl && var.enable_dns ? 1 : 0 
  domain_name       = "${var.environment}.memphis.${var.hostedzonename}"
  validation_method = "DNS"
  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "r53_records" {
  for_each =  var.enable_ssl && var.enable_dns ? {
    for dvo in aws_acm_certificate.cert[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    } 
  } : {}
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.dns[0].zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
  count = var.enable_ssl && var.enable_dns ? 1 : 0
  certificate_arn         = aws_acm_certificate.cert[count.index].arn
  validation_record_fqdns = [for record in aws_route53_record.r53_records : record.fqdn]
}