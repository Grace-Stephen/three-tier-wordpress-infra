### Locals to extract suffixes from ARNs ###
locals {
  alb_arn_suffix = var.alb_arn != "" ? replace(
    var.alb_arn,
    "arn:aws:elasticloadbalancing:us-east-1:[0-9]+:loadbalancer/",
    ""
  ) : ""

  target_group_arn_suffix = var.target_group_arn != "" ? replace(
    var.target_group_arn,
    "arn:aws:elasticloadbalancing:us-east-1:[0-9]+:",
    ""
  ) : ""
}

resource "aws_cloudwatch_dashboard" "wordpress" {
  dashboard_name = "wp-${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      # EC2 CPU Utilization
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          region = var.aws_region
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", element(var.app_instance_ids, 0)]
          ]
          annotations = {}
          period      = 300
          stat        = "Average"
          title       = "EC2 CPU Utilization"
        }
      },

      # ALB Unhealthy Targets
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          region = var.aws_region
          metrics = [
            [
              "AWS/ApplicationELB",
              "UnHealthyHostCount",
              "LoadBalancer",
              local.alb_arn_suffix,
              "TargetGroup",
              local.target_group_arn_suffix
            ]
          ]
          annotations = {}
          period      = 60
          stat        = "Average"
          title       = "ALB Unhealthy Targets"
        }
      },

      # RDS CPU Utilization
      {
        type   = "metric"
        width  = 12
        height = 6
        properties = {
          region = var.aws_region
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.db_instance_identifier]
          ]
          annotations = {}
          period      = 300
          stat        = "Average"
          title       = "RDS CPU Utilization"
        }
      }
    ]
  })

  # Wait for EC2, ALB, and RDS 
  depends_on = var.depends_on_resources
}
