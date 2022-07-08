resource "aws_security_group" "rds-sg" {
  name   = "rds-sg"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.database_security_group.ingress

    content {
      from_port   = ingress.value.from
      protocol    = ingress.value.protocol
      to_port     = ingress.value.to
      cidr_blocks = ingress.value.cidr
    }
  }

  dynamic "egress" {
    for_each = var.database_security_group.egress

    content {
      from_port   = egress.value.from
      protocol    = egress.value.protocol
      to_port     = egress.value.to
      cidr_blocks = egress.value.cidr
    }
  }

  tags = {
    Identity = "${var.infra}-${var.environment}-rds-dg"
  }
}