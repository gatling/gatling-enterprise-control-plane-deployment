resource "aws_ecs_cluster" "gatling_cluster" {
  name = "${var.name}-cluster"
}

locals {
  path           = "/app/conf"
  volume_name    = "control-plane-conf"
  config_content = <<-EOF
    control-plane {
      token = $${?CONTROL_PLANE_TOKEN}
      description = "${var.description}"
      enterprise-cloud = ${jsonencode(var.enterprise-cloud)}
      locations = [ %{for location in var.locations} ${jsonencode(location.conf)}, %{endfor} ]
      %{if length(var.private-package) > 0}repository = ${jsonencode(var.private-package.conf)}%{endif}
      %{for key, value in var.extra-content}${key} = "${value}"%{endfor}
    }
  EOF
  log_group = {
    "awslogs-group" : "/ecs/${var.name}-service"
    "awslogs-region" : var.aws_region
    "awslogs-create-group" : "true"
  }
  token_secret = { name = "CONTROL_PLANE_TOKEN", valueFrom = var.token-secret-arn }
  ecs_secrets  = concat(var.task.secrets, [local.token_secret])
}

resource "aws_ecs_task_definition" "gatling_task" {
  family                   = "${var.name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = var.task.iam-role-arn
  execution_role_arn       = var.task.iam-role-arn
  cpu                      = var.task.cpu
  memory                   = var.task.memory
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
      logConfiguration : var.task.cloudwatch-logs ? {
        logDriver : "awslogs"
        options : merge(local.log_group, { "awslogs-stream-prefix" : "init" })
      } : null
    },
    {
      name : "control-plane"
      image : var.task.image
      command : var.task.command
      cpu : 0
      essential : true
      portMappings : length(var.private-package) > 0 ? [
        {
          containerPort : var.private-package.conf.server.port,
          hostPort : var.private-package.conf.server.port,
          protocol : "tcp"
        }
      ] : []
      workingDirectory : local.path
      secrets : local.ecs_secrets
      environment : var.task.environment
      mountPoints : [
        {
          sourceVolume : local.volume_name
          containerPath : local.path
          readOnly : true
        }
      ]
      logConfiguration : var.task.cloudwatch-logs ? {
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
    subnets          = var.subnets
    security_groups  = var.security-groups
    assign_public_ip = var.assign-public-ip
  }

  depends_on = [aws_ecs_cluster.gatling_cluster, aws_ecs_task_definition.gatling_task]
}
