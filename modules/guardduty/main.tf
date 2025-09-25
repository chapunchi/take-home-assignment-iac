resource "aws_guardduty_detector" "main" {
  enable = true

  tags = {
    Environment = "gic-dev"
  }
}