resource "aws_route53_record" "staging" {
  zone_id = data.terraform_remote_state.dns.outputs.zone_id
  name    = "staging.ogomawoman.store"
  type    = "A"

  alias {
    name    = module.alb.alb_dns_name
    zone_id = module.alb.alb_zone_id
    evaluate_target_health = false
  }
}
