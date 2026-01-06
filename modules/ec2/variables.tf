variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "instance_type" {
  type = string
}


variable "db_host" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "domain_name" {
  type = string
}


variable "instance_profile_name" {
  type = string
  default = "ec2_profile"
}

variable "db_password" {
  type      = string
  sensitive = true
}

#