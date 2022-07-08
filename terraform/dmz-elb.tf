resource "aws_lb" "app-alb" {
  name                       = "app-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = aws_security_group.dmz-sg.*.id
  subnets                    = aws_subnet.dmz.*.id
  enable_deletion_protection = false

  tags = {
    Name = "${var.infra}-${var.environment}-app-alb"
  }
}

resource "aws_lb_target_group" "app-alb-tg" {
  name        = "app-alb-tg"
  port        = var.alb_settings.port
  protocol    = var.alb_settings.protocol
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"

  health_check {
    interval            = var.alb_settings.interval
    path                = "/"
    port                = var.alb_settings.port
    healthy_threshold   = var.alb_settings.healthy
    unhealthy_threshold = var.alb_settings.unhealthy
    timeout             = var.alb_settings.timeout
    protocol            = var.alb_settings.protocol
    matcher             = var.alb_settings.healthy_match
  }
}

resource "aws_lb_listener" "app-alb-listener" {
  load_balancer_arn = aws_lb.app-alb.arn
  port              = var.alb_settings.port
  protocol          = var.alb_settings.protocol

  default_action {
    target_group_arn = aws_lb_target_group.app-alb-tg.arn
    type             = var.alb_settings.action
  }
}