resource "aws_lb" "application" {
  name               = "wordpress-alb${var.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "coinlabs-${var.env}"
  }
}

resource "aws_lb_target_group" "http" {
  name     = "wordpress-http-tg${var.env}"
  port     = var.port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "http" {
  count = length(var.instance_ids)

  target_group_arn = aws_lb_target_group.http.arn
  target_id        = element(var.instance_ids, count.index)
  port             = var.port
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.application.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.application.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}
