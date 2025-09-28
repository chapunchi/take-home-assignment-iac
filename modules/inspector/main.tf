data "aws_caller_identity" "current" {}

resource "aws_inspector2_enabler" "ecr_scans" {
  account_ids   = [data.aws_caller_identity.current.account_id]
  resource_types = ["ECR"]
}


resource "aws_iam_service_linked_role" "inspector" {
  aws_service_name = "inspector2.amazonaws.com"

  tags = {
    Environment = "gic-dev"
  }
}
