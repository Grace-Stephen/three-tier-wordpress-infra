output "app_security_group_id" {
  value = aws_security_group.app.id
}

output "app_instance_ids" {
  value = aws_instance.app[*].id
}

output "private_ips" {
  value = aws_instance.app[*].private_ip
}

##