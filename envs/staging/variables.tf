variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"
}

####### NETWORK #################
variable "environment" {
  default = "staging"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_app_subnet_cidrs" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_db_subnet_cidrs" {
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

####### IAM ################

variable "ec2_role_name" {
  type    = string
  default = "web-app-ec2-role"
}

variable "instance_profile_name" {
  type = string
  default = "ec2_profile"
}

variable "ec2_policy_arns" {
  type = list(string)

  default = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
}

####### RDS ################

variable "db_name" {
  default = "wordpress"
}

variable "db_username" {
  default = "wpadmin"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  default = "db.t3.micro"
}

variable "allocated_storage" {
  default = 20
}

######EC2########
variable "instance_type" {
  type = string
}

######ACM########
variable "domain_name" {
  type = string
}

variable "subject_alternative_names" {
  type = list(string)
}

######CLOUDWATCH#######
variable "ec2_instance_ids" {
  type    = list(string)
  default = []
}


variable "rds_instance_identifier" {
  type = string
}

variable "cpu_utilization_threshold" {
  description = "CPU utilization percentage that triggers alarm"
  type        = number
  default     = 80
}

variable "alarm_evaluation_periods" {
  description = "Number of periods to evaluate before triggering alarm"
  type        = number
  default     = 2
}

variable "alarm_period" {
  description = "Period (in seconds) over which the metric is evaluated"
  type        = number
  default     = 300
}

