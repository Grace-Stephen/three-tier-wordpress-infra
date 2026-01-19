
###ROUTE 53######
 resource "aws_route53_zone" "root" {
  name = "ogomawoman.store"
}

#### ACM CERT #####
resource "aws_acm_certificate" "certs" {
  for_each          = var.domains
  domain_name       = each.value
  validation_method = "DNS"
}

## validation records
resource "aws_route53_record" "validation" {
  for_each = aws_acm_certificate.certs

  zone_id = aws_route53_zone.root.zone_id
  name    = tolist(each.value.domain_validation_options)[0].resource_record_name
  type    = tolist(each.value.domain_validation_options)[0].resource_record_type
  records = [tolist(each.value.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

## cert validation
resource "aws_acm_certificate_validation" "certs" {
  for_each = aws_acm_certificate.certs

  certificate_arn         = each.value.arn
  validation_record_fqdns = [aws_route53_record.validation[each.key].fqdn]
}
