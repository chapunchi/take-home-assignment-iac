resource "aws_cloudwatch_log_group" "flow_log_group" {
  name              = "/aws/vpc/gic-flow-logs"
  retention_in_days = 30

  tags = {
    Environment = "gic-dev"
  }
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "vpc-gic-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = "gic-dev"
  }
}

resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "vpc-gic-flow-logs-policy"
  role = aws_iam_role.vpc_flow_logs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_flow_log" "flow_log" {
  log_destination      = aws_cloudwatch_log_group.flow_log_group.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  iam_role_arn         = aws_iam_role.vpc_flow_logs_role.arn
  vpc_id               = var.vpc_id

  tags = {
    Environment = "gic-dev"
  }
}