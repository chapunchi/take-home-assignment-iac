data "aws_dynamodb_table" "accounts" {
  name = "Accounts"
}

# resource "aws_dynamodb_table_item" "table_item" {
#   table_name = data.aws_dynamodb_table.accounts.name
#   hash_key   = data.aws_dynamodb_table.accounts.hash_key

#   item = <<ITEM
# {
#   "account_id": {"S": "8888888"},
#   "current_balance": {"N": "1000"},
#   "first_name": {"S": "fname"},
#   "last_name": {"S": "lname"},
#   "daily_limit": {"N": "500"},
#   "daily_amount_withdrawn": {"N": "100"}
# }
# ITEM
# }