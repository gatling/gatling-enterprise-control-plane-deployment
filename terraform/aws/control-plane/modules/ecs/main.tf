locals {
  conf_path      = "/app/conf"
  ssh_path       = "/app/.ssh"
  git_path       = "${local.conf_path}/.git-credentials"
  volume_name    = "control-plane-volume"
  config_content = <<-EOF
    control-plane {
      token = $${?CONTROL_PLANE_TOKEN}
      description = "${var.description}"
      enterprise-cloud = ${jsonencode(var.enterprise-cloud)}
      locations = [%{for location in var.locations} ${jsonencode(location.conf)}, %{endfor}]
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
  git = {
    ssh_enabled   = length(var.git.ssh.private-key-secret-arn) > 0
    creds_enabled = length(var.git.credentials.username) > 0 && length(var.git.credentials.token-secret-arn) > 0
  }
  mountPoints = concat(
    [
      {
        sourceVolume : local.volume_name
        containerPath : local.conf_path
        readOnly : true
      }
    ],
    local.git.ssh_enabled ? [
      {
        sourceVolume : local.volume_name
        containerPath : local.ssh_path
        readOnly : true
      }
    ] : [],
    [
      for cache_path in var.git.cache.paths : {
        sourceVolume  = local.volume_name
        containerPath = cache_path
        readOnly      = false
      }
  ])
  init_commands = compact([
    "echo \"$CONFIG_CONTENT\" > ${local.conf_path}/control-plane.conf && chown -R 1001 ${local.conf_path} && chmod 400 ${local.conf_path}/control-plane.conf",
    local.git.ssh_enabled ? "echo 'Host ${var.git.host}\n IdentityFile ${local.ssh_path}/id_gatling\n  StrictHostKeyChecking no' >> ${local.ssh_path}/config && echo \"$SSH_KEY\" > ${local.ssh_path}/id_gatling && chown -R 1001 ${local.ssh_path} && chmod 400 ${local.ssh_path}/id_gatling" : "",
    local.git.creds_enabled ? "echo \"https://$GIT_USERNAME:$GIT_TOKEN@${var.git.host}\" > ${local.git_path} && chown -R 1001 ${local.conf_path} && chmod 400 ${local.git_path}" : "",
  ])
  init = {
    command = [
      "/bin/sh",
      "-c",
      join(" && ", local.init_commands)
    ]
    secrets = concat(
      local.git.creds_enabled ? [
        {
          name      = "GIT_TOKEN"
          valueFrom = var.git.credentials.token-secret-arn
        }
      ] : [],
      local.git.ssh_enabled ? [
        {
          name      = "SSH_KEY"
          valueFrom = var.git.ssh.private-key-secret-arn
        }
      ] : []
    )
    environment = concat(
      [
        {
          name  = "CONFIG_CONTENT"
          value = local.config_content
        }
      ],
      local.git.creds_enabled ? [
        {
          name  = "GIT_USERNAME"
          value = var.git.credentials.username
        },
        {
          name  = "GIT_CREDENTIALS"
          value = local.git_path
        }
      ] : []
    )
    mountPoints = concat(
      [
        {
          sourceVolume : local.volume_name
          containerPath : local.conf_path
          readOnly : false
        }
      ],
      local.git.ssh_enabled ? [
        {
          sourceVolume : local.volume_name
          containerPath : local.ssh_path
          readOnly : false
        }
    ] : [])
  }
}

resource "aws_ecs_cluster" "gatling_cluster" {
  name = "${var.name}-cluster"
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
      image : var.task.init.image
      cpu : 0
      essential : false
      command : local.init.command
      environment : local.init.environment
      secrets : local.init.secrets
      mountPoints : local.init.mountPoints
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
      workingDirectory : local.conf_path
      secrets : local.ecs_secrets
      environment : concat(var.task.environment, local.git.creds_enabled ? [{
        name  = "GIT_CREDENTIALS"
        value = local.git_path
      }] : [])
      mountPoints : local.mountPoints
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
