data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "david-${var.environment}-secrets"
}

locals {
  secrets = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
}

