resource "aws_s3_bucket" "config_bucket" {
  bucket = "gic-config-bucket"

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

resource "aws_s3_bucket_versioning" "enables" {
  bucket = aws_s3_bucket.config_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.config_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.config_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_role" "config" {
  name = "gic-config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "config.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Environment = "gic-dev"
  }
}

resource "aws_iam_role_policy" "gic_config_policy" {
  name = "gic-config-role-inline"
  role = aws_iam_role.config.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:PutObject",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
        Resource = [
          "${aws_s3_bucket.config_bucket.arn}/*",
           aws_s3_bucket.config_bucket.arn
        ]
      },
      {
        Effect   = "Allow"
        Action   = [
          "config:Put*",
          "config:Get*",
          "config:Describe*",
          "config:List*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_config_configuration_recorder" "rec" {
  name     = "gic-config-recorder"
  role_arn = aws_iam_role.config.arn

  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

resource "aws_iam_role_policy_attachment" "config_attach" {
  role       = aws_iam_role.config.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}



resource "aws_config_delivery_channel" "delivery" {
  name           = "gic-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config_bucket.bucket
  depends_on     = [aws_config_configuration_recorder.rec]
}