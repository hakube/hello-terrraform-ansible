resource "aws_db_instance" "default" {
  availability_zone      = var.az[0]
  allocated_storage      = var.database_settings.allocated_storage
  engine                 = var.database_settings.engine
  engine_version         = var.database_settings.engine_version
  instance_class         = var.database_settings.instance_class
  db_name                = var.database_settings.name
  username               = "${local.secrets.pgsql_user}"
  password               = "${local.secrets.pgsql_password}"
  parameter_group_name   = aws_db_parameter_group.default.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds.id
  identifier             = var.database_settings.identifier
  skip_final_snapshot    = true
}

resource "aws_db_parameter_group" "default" {
  name   = "david-rds-pg"
  family = "postgres13"

}