resource "aws_codedeploy_app" "main" {
  compute_platform = "ECS"
  name             = local.app_name

  depends_on = [
    aws_ecs_service.main
  ]
}

resource "aws_codedeploy_deployment_group" "main" {
  app_name               = resource.aws_codedeploy_app.main.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${local.app_name}-deploymentgroup"
  service_role_arn       = var.service_role_codedeploy_arn

  ecs_service {
    cluster_name = data.terraform_remote_state.ecs.outputs.cluster_name
    service_name = local.app_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.http.arn]
      }

      target_group {
        name = aws_lb_target_group.main.*.name[0]
      }

      target_group {
        name = aws_lb_target_group.main.*.name[1]
      }
    }
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 1
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }
}
