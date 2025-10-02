data "aws_dynamodb_table" "accounts" {
  name = "Accounts"
}

resource "aws_dynamodb_table_item" "table_item" {
  for_each   = { for acct in var.accounts : acct.account_id => acct }
  table_name = data.aws_dynamodb_table.accounts.name
  hash_key   = data.aws_dynamodb_table.accounts.hash_key

  item = jsonencode({
    account_id             = { S = each.value.account_id }
    current_balance        = { N = each.value.current_balance }
    first_name             = { S = each.value.first_name }
    last_name              = { S = each.value.last_name }
    daily_limit            = { N = each.value.daily_limit }
    daily_amount_withdrawn = { N = each.value.daily_amount_withdrawn }
  })
}