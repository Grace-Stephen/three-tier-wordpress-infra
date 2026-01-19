output "zone_id" {
  value = aws_route53_zone.root.zone_id
}

output "zone_name" {
  value = aws_route53_zone.root.name
}


output "certificate_arns" {
  value = {
    for k, cert in aws_acm_certificate.certs :
    k => cert.arn
  }
}
