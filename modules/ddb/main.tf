data "aws_dynamodb_table" "accounts" {
  name = "Accounts"
}

resource "aws_dynamodb_table_item" "table_item" {
  table_name = data.aws_dynamodb_table.accounts
  hash_key   = data.aws_dynamodb_table.hash_key

  item = <<ITEM
{
  "account_id": {"S": "something"},
  "current_balance": {"N": "11111"},
  "first_name": {"S": "22222"},
  "last_name": {"S": "33333"},
  "daily_limit": {"N": "44444"}
}
ITEM
}