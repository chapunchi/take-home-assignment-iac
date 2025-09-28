resource "aws_ecr_repository" "ecr_repo" {
  name = "gic-artifacts"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = "gic-dev"
  }
}