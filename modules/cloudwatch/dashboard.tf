resource "aws_cloudwatch_dashboard" "wordpress" {
  dashboard_name = "wp-${var.environment}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        width = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", element(var.ec2_instance_ids, 0)]
          ]
          period = 300
          stat   = "Average"
          title  = "EC2 CPU Utilization"
        }
      },
      {
        type = "metric"
        width = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "UnHealthyHostCount", "LoadBalancer", var.alb_arn, "TargetGroup", var.target_group_arn]
          ]
          period = 60
          stat   = "Average"
          title  = "ALB Unhealthy Targets"
        }
      },
      {
        type = "metric"
        width = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.rds_instance_identifier]
          ]
          period = 300
          stat   = "Average"
          title  = "RDS CPU Utilization"
        }
      }
    ]
  })
}
