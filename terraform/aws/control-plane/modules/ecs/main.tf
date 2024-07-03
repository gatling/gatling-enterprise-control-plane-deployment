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
      name : "conf-loader-side-car"
      image : "amazon/aws-cli"
      cpu : 0
      essential : false
      entryPoint : ["aws", "s3", "cp", "s3://${var.conf_s3_name}/control-plane.conf", "/app/conf/control-plane.conf"]
      mountPoints : [
        {
          sourceVolume : "control-plane-conf"
          containerPath : "/app/conf"
          readOnly : false
        }
      ]
    },
    {
      name : "control-plane"
      image : var.image
      command: var.command,
      cpu : 0
      essential : true
      portMappings : length(var.private_package) > 0 ? [
        {
          containerPort : 8080,
          hostPort : 8080,
          protocol : "tcp"
        }
      ] : [],
      mountPoints : [
        {
          sourceVolume : "control-plane-conf"
          containerPath : "/app/conf"
          readOnly : true
        }
      ]
      dependsOn = [
        {
          containerName : "conf-loader-side-car"
          condition : "SUCCESS"
        }
      ]
      workingDirectory : "/app/conf"
    }
  ])

  volume {
    name = "control-plane-conf"
  }
}

resource "aws_ecs_cluster" "gatling_cluster" {
  name = "${var.name}-cluster"
}

resource "aws_ecs_service" "gatling_service" {
  name            = "${var.name}-service"
  cluster         = aws_ecs_cluster.gatling_cluster.id
  task_definition = aws_ecs_task_definition.gatling_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  dynamic "load_balancer" {
    for_each = length(var.private_package) > 0 ? [1] : []
    content {
      target_group_arn = length(var.private_package) > 0 ? var.alb_target_group_arn : ""
      container_name   = "control-plane"
      container_port   = 8080
    }
  }

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }

  depends_on = [aws_ecs_task_definition.gatling_task]
}
