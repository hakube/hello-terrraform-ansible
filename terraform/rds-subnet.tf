resource "aws_db_subnet_group" "rds" {
  name       = "rds"
  subnet_ids = aws_subnet.app.*.id

  tags = {
    Identity = "sb-rds-${var.environment}"
  }
}