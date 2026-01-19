# --- Network Outputs ---

output "vpc_id" {
  description = "Staging VPC ID"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Staging public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Staging private app subnet IDs"
  value       = module.network.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "Staging private DB subnet IDs"
  value       = module.network.private_db_subnet_ids
}


# --- IAM Outputs ---
output "ec2_instance_profile_name" {
  value = module.iam.instance_profile_name
}

output "ec2_role_name" {
  value = module.iam.ec2_role_name
}

# --- EC2 Outputs ---
output "app_security_group_id" {
  value = module.ec2.app_security_group_id
}

# --- RDS Outputs ---
output "db_endpoint" {
  description = "RDS endpoint for the WordPress application"
  value       = module.rds.db_endpoint
}

output "db_name" {
  description = "RDS database name"
  value       = module.rds.db_name
}

output "db_port" {
  description = "RDS port"
  value       = module.rds.db_port
}

output "db_instance_identifier" {
  value = module.rds.db_instance_identifier
}
# --- EC2 Outputs ---
output "app_instance_ids" {
  value = module.ec2.app_instance_ids
}

output "app_private_ips" {
  value = module.ec2.private_ips
}

# --- ALB Outputs ---
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "alb_zone_id" {
  value = module.alb.alb_zone_id
}

output "alb_security_group_id" {
  value = module.alb.alb_security_group_id
}


# # --- ACM Outputs ---
# output "acm_validation_records" {
#   value = module.acm.acm_validation_records
# }

# output "certificate_arn" {
#   value = module.acm.certificate_arn
# }
