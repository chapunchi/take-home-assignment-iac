resource "aws_securityhub_account" "this" {}

data "aws_region" "current" {}

resource "aws_securityhub_standards_subscription" "cis_aws_foundations" {
  depends_on = [aws_securityhub_account.this]

  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}

resource "aws_securityhub_standards_subscription" "pci_321" {
  depends_on    = [aws_securityhub_account.this]
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.region}::standards/pci-dss/v/3.2.1"
}
