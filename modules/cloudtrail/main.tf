resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "gic-cloudtrail-logs"

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      tags,
      versioning
    ]
  }

  tags = {
    Environment = "gic-dev"
  }
}

resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name              = "/aws/cloudtrail/gic"
  retention_in_days = 90

  tags = {
    Environment = "gic-dev"
  }
}

resource "aws_s3_bucket_versioning" "enables" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.cloudtrail_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "gic" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AWSCloudTrailWrite"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.cloudtrail_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid       = "AWSCloudTrailRead"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = [
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
        Resource = aws_s3_bucket.cloudtrail_bucket.arn
      }
    ]
  })
}

data "aws_caller_identity" "current" {}



resource "aws_iam_role" "cloudtrail_cw" {
  name = "cloudtrail-cw-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "cloudtrail.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Environment = "gic-dev"
  }
}

resource "aws_iam_role_policy" "cloudtrail_cw_policy" {
  name = "cloudtrail-cw-policy"
  role = aws_iam_role.cloudtrail_cw.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*" 
    }]
  })
}

resource "aws_cloudtrail" "gic_trail_with_logs" {
  depends_on = [
    aws_cloudwatch_log_group.cloudtrail_logs,
    aws_iam_role_policy.cloudtrail_cw_policy
  ]

  name                          = "gic-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.bucket
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_cw.arn
  include_global_service_events = true
  is_multi_region_trail         = false
  enable_log_file_validation    = false

  tags = {
    Environment = "gic-dev"
  }
}