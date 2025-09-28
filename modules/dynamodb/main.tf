resource "aws_dynamodb_table" "accounts" {
  name         = "Accounts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "account_id"

  attribute {
    name = "account_id"
    type = "S"
  }

  tags = {
    Environment = "gic-dev"
  }

  server_side_encryption {
    enabled     = true
  }
}

