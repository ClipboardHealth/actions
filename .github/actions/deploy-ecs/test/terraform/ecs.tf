resource "aws_security_group" "main" {
  name        = "${local.app_name}-sg"
  description = "Allow ${local.app_name} ports within the VPC, and browsing from the outside"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  ingress {
    from_port   = local.port
    to_port     = local.port
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.networking.outputs.vpc_cidr]
    description = "Allow connection to Service Port"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outside"
  }
}

resource "aws_ecs_task_definition" "main" {
  family                   = local.app_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 128
  memory                   = 128

  container_definitions = jsonencode([
    {
      essential = true
      cpu       = 128
      memory    = 128
      image     = "nginx:stable-alpine"
      name      = local.app_name
      portMappings = [
        {
          containerPort = local.port
          hostPort      = local.port
        }
      ]
    }
  ])

  lifecycle {
    ignore_changes = [
      container_definitions
    ]
  }
}

resource "aws_ecs_service" "main" {
  name          = local.app_name
  cluster       = data.terraform_remote_state.ecs.outputs.cluster_name
  desired_count = 0

  network_configuration {
    subnets          = data.terraform_remote_state.networking.outputs.subnets_private
    security_groups  = [aws_security_group.main.id]
    assign_public_ip = false
  }

  scheduling_strategy    = "REPLICA"
  enable_execute_command = false

  service_registries {
    registry_arn = data.terraform_remote_state.ecs.outputs.aws_service_discovery_service_arn
  }

  task_definition = "${resource.aws_ecs_task_definition.main.family}:${resource.aws_ecs_task_definition.main.revision}"

  load_balancer {
    target_group_arn = aws_lb_target_group.main.*.arn[0]
    container_name   = local.app_name
    container_port   = local.port
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      load_balancer,
      task_definition
    ]
  }
}
