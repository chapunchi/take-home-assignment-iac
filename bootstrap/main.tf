resource "aws_s3_bucket" "tf_state" {
  bucket = "gic-terraform-state-bucket"

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      tags,
      acl,
      versioning
    ]
  }
}

// Enable bucket versioning
resource "aws_s3_bucket_versioning" "enables" {
  bucket = aws_s3_bucket.tf_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

// Enable S3 server side encryption 
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

// Block public access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}