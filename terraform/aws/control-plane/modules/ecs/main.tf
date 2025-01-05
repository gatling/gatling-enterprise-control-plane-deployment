resource "aws_ecs_cluster" "gatling_cluster" {
  name = "${var.name}-cluster"
}

data "aws_region" "current" {}

locals {
  path           = "/app/conf"
  volume_name    = "control-plane-conf"
  config_content = <<-EOF
    control-plane {
      token = $${?CONTROL_PLANE_TOKEN}
      description = "${var.description}"
      enterprise-cloud = { %{for key, value in var.enterprise_cloud} ${key} = "${value}" %{endfor} }
      locations = [ %{for location in var.locations} ${jsonencode(location.conf)}, %{endfor} ]
      %{if length(var.private_package) > 0}repository = ${jsonencode(var.private_package.conf)}%{endif}
      %{for key, value in var.extra_content}${key} = "${value}"%{endfor}
    }
  EOF
  log_group = {
    "awslogs-group" : "/ecs/${var.name}-service"
    "awslogs-region" : data.aws_region.current.name
    "awslogs-create-group" : "true"
  }
  token_secret = { name = "CONTROL_PLANE_TOKEN", valueFrom = var.token_secret_arn }
  ecs_secrets  = concat(var.secrets, [local.token_secret])
}

resource "aws_ecs_task_definition" "gatling_task" {
  family                   = "${var.name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = var.ecs_tasks_iam_role_arn
  execution_role_arn       = var.ecs_tasks_iam_role_arn
  cpu                      = "1024"
  memory                   = "3072"

  container_definitions = jsonencode([
    {
      name : "conf-loader-init-container"
      image : "busybox"
      cpu : 0
      essential : false
      command : [
        "/bin/sh",
        "-c",
        "echo \"$CONFIG_CONTENT\" > ${local.path}/control-plane.conf"
      ]
      environment : [
        {
          name : "CONFIG_CONTENT",
          value : local.config_content
        }
      ]
      mountPoints : [
        {
          sourceVolume : local.volume_name
          containerPath : local.path
          readOnly : false
        }
      ]
      logConfiguration : var.cloudWatch_logs ? {
        logDriver : "awslogs"
        options : merge(local.log_group, { "awslogs-stream-prefix" : "init" })
      } : null
    },
    {
      name : "control-plane"
      image : var.image
      command : var.command
      cpu : 0
      essential : true
      portMappings : length(var.private_package) > 0 ? [
        {
          containerPort : var.private_package.conf.server.port,
          hostPort : var.private_package.conf.server.port,
          protocol : "tcp"
        }
      ] : []
      workingDirectory : local.path
      secrets : local.ecs_secrets
      environment : var.environment
      mountPoints : [
        {
          sourceVolume : local.volume_name
          containerPath : local.path
          readOnly : true
        }
      ]
      logConfiguration : var.cloudWatch_logs ? {
        logDriver : "awslogs"
        options : merge(local.log_group, { "awslogs-stream-prefix" : "main" })
      } : null
      dependsOn : [
        {
          containerName : "conf-loader-init-container"
          condition : "SUCCESS"
        }
      ]
    }
  ])

  volume {
    name = local.volume_name
  }
}

resource "aws_ecs_service" "gatling_service" {
  name            = "${var.name}-service"
  cluster         = aws_ecs_cluster.gatling_cluster.id
  task_definition = aws_ecs_task_definition.gatling_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }

  depends_on = [aws_ecs_cluster.gatling_cluster, aws_ecs_task_definition.gatling_task]
}
