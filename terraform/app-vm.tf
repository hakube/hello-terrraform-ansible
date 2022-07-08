resource "aws_launch_configuration" "app-launch-config" {
  name            = "app-launch-config"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.app.instance_type
  key_name        = aws_key_pair.bootstrap-key.id
  security_groups = [aws_security_group.app-sg.id]
  user_data       = file("instance-init.sh")
}

resource "aws_autoscaling_group" "app-asg" {
  name                 = "app-asg"
  vpc_zone_identifier  = aws_subnet.app.*.id
  launch_configuration = aws_launch_configuration.app-launch-config.id
  target_group_arns    = [aws_lb_target_group.app-alb-tg.arn]
  desired_capacity     = 2
  max_size             = 2
  min_size             = 1

  tag {
    key                 = "Name"
    value               = "${var.infra}-${var.environment}-app-instance"
    propagate_at_launch = true
  }
}