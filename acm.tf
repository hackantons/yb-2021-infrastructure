resource "aws_acm_certificate" "yb_dev" {
  domain_name               = "backend.bscyb.dev"
  validation_method         = "DNS"
  subject_alternative_names = ["*.backend.bscyb.dev"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.yb_dev.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = "ZFBOS8JU7J1RP"
  ttl             = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.yb_dev.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

}
