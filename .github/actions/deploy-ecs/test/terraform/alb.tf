locals {
  target_groups = [
    "green",
    "blue"
  ]
}

resource "aws_security_group" "alb" {
  name        = "${local.app_name}-alb-sg"
  description = "Allow HTTP and HTTPS from the outside"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  ingress {
    from_port   = local.port
    to_port     = local.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP to ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "main" {
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.terraform_remote_state.networking.outputs.subnets_private
}

resource "aws_lb_target_group" "main" {
  count       = length(local.target_groups)
  port        = local.port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  health_check {
    interval = 30
    path     = "/health"
    port     = local.port
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = resource.aws_lb.main.arn
  port              = local.port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.*.arn[0]
  }
}
