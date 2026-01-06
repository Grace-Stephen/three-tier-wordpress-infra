variable "environment" {
  type = string
}

variable "ec2_instance_ids" {
  type = list(string)
}

variable "alb_arn_suffix" {
  type = string
}

variable "target_group_arn_suffix" {
  type = string
}

variable "rds_instance_identifier" {
  type = string
}
