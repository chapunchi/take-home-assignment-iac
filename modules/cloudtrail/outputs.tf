output "cloudtrail_logs_arn" {
  value = aws_cloudwatch_log_group.cloudtrail_logs.arn
}