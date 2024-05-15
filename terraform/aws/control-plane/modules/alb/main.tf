resource "aws_lb" "gatling_alb" {
  count              = length(var.private_package) > 0 ? 1 : 0
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "gatling_tg" {
  count    = length(var.private_package) > 0 ? 1 : 0
  name     = "${var.name}-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 10
    unhealthy_threshold = 10
    timeout             = 10
    matcher             = "200"
  }

  target_type = "ip"
}

resource "aws_lb_listener" "gatling_listener" {
  count             = length(var.private_package) > 0 ? 1 : 0
  load_balancer_arn = aws_lb.gatling_alb[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gatling_tg[0].arn 
  }
}