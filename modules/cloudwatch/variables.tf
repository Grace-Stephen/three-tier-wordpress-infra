variable "environment" {
  type = string
}

variable "ec2_instance_ids" {
  type = list(string)
}

variable "rds_instance_identifier" {
  type = string
}
