variable "environment" {
  description = "Environment name (e.g. staging, production)"
  type        = string
}

variable "ec2_role_name" {
  description = "Base name for EC2 IAM role"
  type        = string
}

variable "ec2_policy_arns" {
  description = "List of IAM policy ARNs to attach to the EC2 role"
  type        = list(string)
}
