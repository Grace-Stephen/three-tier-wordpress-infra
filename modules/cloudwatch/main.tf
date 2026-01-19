### Locals for static keys ###
locals {
  # EC2 alarms: keys are static indices
  ec2_alarms = { for idx, id in var.app_instance_ids : idx => id if id != "" }

  # ALB alarms: keys are static, values can be unknown at apply
  alb_alarms = {
    "5xx_errors"        = var.alb_arn
    "high_latency"      = var.alb_arn
    "unhealthy_targets" = var.target_group_arn
    "no_healthy_targets"= var.target_group_arn
  }
}

### EC2 CPU Alarms ###
resource "aws_cloudwatch_metric_alarm" "ec2_high_cpu" {
  for_each = local.ec2_alarms

  alarm_name          = "ec2-high-cpu-${each.value}-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = each.value
  }

  depends_on = var.depends_on_resources
}

### ALB 5XX Errors Alarm ###
resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  for_each = { for k, v in local.alb_alarms : k => v if k == "5xx_errors" && v != "" }

  alarm_name          = "alb-5xx-errors-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 1

  dimensions = {
    LoadBalancer = replace(each.value, "arn:aws:elasticloadbalancing:us-east-1:[0-9]+:loadbalancer/", "")
  }

  depends_on = var.depends_on_resources
}

### Target Group Unhealthy Hosts Alarm ###
resource "aws_cloudwatch_metric_alarm" "unhealthy_targets" {
  for_each = { for k, v in local.alb_alarms : k => v if k == "unhealthy_targets" && v != "" }

  alarm_name          = "unhealthy-targets-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0

  dimensions = {
    TargetGroup  = replace(each.value, "arn:aws:elasticloadbalancing:us-east-1:[0-9]+:", "")
    LoadBalancer = replace(var.alb_arn, "arn:aws:elasticloadbalancing:us-east-1:[0-9]+:loadbalancer/", "")
  }

  depends_on = var.depends_on_resources
}

### ALB No Healthy Targets Alarm ###
resource "aws_cloudwatch_metric_alarm" "alb_no_healthy_targets" {
  for_each = { for k, v in local.alb_alarms : k => v if k == "no_healthy_targets" && v != "" }

  alarm_name          = "alb-no-healthy-targets-${var.environment}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1

  dimensions = {
    TargetGroup  = replace(each.value, "arn:aws:elasticloadbalancing:us-east-1:[0-9]+:", "")
    LoadBalancer = replace(var.alb_arn, "arn:aws:elasticloadbalancing:us-east-1:[0-9]+:loadbalancer/", "")
  }

  depends_on = var.depends_on_resources
}

### ALB High Latency Alarm ###
resource "aws_cloudwatch_metric_alarm" "alb_high_latency" {
  for_each = { for k, v in local.alb_alarms : k => v if k == "high_latency" && v != "" }

  alarm_name          = "alb-high-latency-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 3

  dimensions = {
    LoadBalancer = replace(each.value, "arn:aws:elasticloadbalancing:us-east-1:[0-9]+:loadbalancer/", "")
  }

  depends_on = var.depends_on_resources
}

### RDS CPU Alarm ###
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  count = var.db_instance_identifier != "" ? 1 : 0

  alarm_name          = "rds-high-cpu-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 75

  dimensions = {
    DBInstanceIdentifier = var.db_instance_identifier
  }

  depends_on = var.depends_on_resources
}

resource "aws_cloudwatch_metric_alarm" "rds_low_storage" {
  count = var.db_instance_identifier != "" ? 1 : 0

  alarm_name          = "rds-low-storage-${var.environment}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 2147483648 # 2 GB

  dimensions = {
    DBInstanceIdentifier = var.db_instance_identifier
  }

  depends_on = var.depends_on_resources
}
