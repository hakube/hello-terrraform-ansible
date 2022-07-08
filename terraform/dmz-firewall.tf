resource "aws_security_group" "dmz-sg" {
  name   = "dmz-sg-${var.environment}"
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.dmz_security_group.ingress

    content {
      description = ingress.value.desc
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr
    }
  }
  dynamic "egress" {
    for_each = var.dmz_security_group.egress

    content {
      description = egress.value.desc
      from_port   = egress.value.from
      to_port     = egress.value.to
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr
    }
  }
  tags = {
    Name = "${var.infra}-${var.environment}-dmz-sg"
  }
}