locals {
  alb_arn_suffix          = var.alb_arn != "" ? replace(var.alb_arn, "arn:aws:elasticloadbalancing:us-east-1:[0-9]+:loadbalancer/", "") : null
  target_group_arn_suffix = var.target_group_arn != "" ? replace(var.target_group_arn, "arn:aws:elasticloadbalancing:us-east-1:[0-9]+:", "") : null
}

### EC2 CPU Alarms
resource "aws_cloudwatch_metric_alarm" "ec2_high_cpu" {
  for_each = toset(compact(var.app_instance_ids))

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
}

### ALB 5XX Errors Alarm
resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  for_each = var.alb_arn != "" ? { "alarm" = var.alb_arn } : {}

  alarm_name          = "alb-5xx-errors-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 1

  dimensions = {
    LoadBalancer = local.alb_arn_suffix
  }
}

### Target Group Unhealthy Hosts Alarm
resource "aws_cloudwatch_metric_alarm" "unhealthy_targets" {
  for_each = var.target_group_arn != "" && var.alb_arn != "" ? { "alarm" = var.target_group_arn } : {}

  alarm_name          = "unhealthy-targets-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0

  dimensions = {
    TargetGroup  = local.target_group_arn_suffix
    LoadBalancer = local.alb_arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_no_healthy_targets" {
  for_each = var.target_group_arn != "" && var.alb_arn != "" ? { "alarm" = var.target_group_arn } : {}

  alarm_name          = "alb-no-healthy-targets-${var.environment}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1

  dimensions = {
    TargetGroup  = local.target_group_arn_suffix
    LoadBalancer = local.alb_arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_high_latency" {
  for_each = var.alb_arn != "" ? { "alarm" = var.alb_arn } : {}

  alarm_name          = "alb-high-latency-${var.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 3

  dimensions = {
    LoadBalancer = local.alb_arn_suffix
  }
}

### RDS Alarms
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  for_each = var.db_instance_identifier != "" ? { "alarm" = var.db_instance_identifier } : {}

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
}

resource "aws_cloudwatch_metric_alarm" "rds_low_storage" {
  for_each = var.db_instance_identifier != "" ? { "alarm" = var.db_instance_identifier } : {}

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
}
