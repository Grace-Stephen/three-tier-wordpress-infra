variable "environment" {
  type        = string
  description = "Environment name (staging/prod)"
}

variable "aws_region" {
  type        = string
  description = "AWS region for CloudWatch dashboard widgets"
}


variable "app_instance_ids" {
  type        = list(string)
  description = "List of EC2 instance IDs to monitor"
  default     = []          
}

variable "db_instance_identifier" {
  type        = string
  description = "RDS DB instance identifier"
  default     = ""          
}

variable "alb_arn" {
  type        = string
  description = "The ARN of the ALB to monitor"
  default     = ""          
}

variable "target_group_arn" {
  type        = string
  description = "The ARN of the ALB target group"
  default     = ""          
}

variable "depends_on_resources" {
  description = "Resources or modules that CloudWatch should depend on"
  type        = any
  default     = []
}