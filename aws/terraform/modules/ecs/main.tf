resource "aws_ecs_task_definition" "gatling_task" {
  family                   = "${var.cp_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = var.cp_iam_role_arn
  execution_role_arn       = var.cp_iam_role_arn
  cpu                      = "1024"
  memory                   = "3072"

  container_definitions = jsonencode([
    {
      name : "conf-loader-side-car"
      image : "amazon/aws-cli"
      cpu : 0
      essential : false
      entryPoint : ["aws", "s3", "cp", "s3://${var.cp_name}-s3/control-plane.conf", "/app/conf/control-plane.conf"]
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
      image : "gatlingcorp/control-plane:latest"
      cpu : 0
      essential : true
      portMappings : var.pp_flag ? [
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
  name = "${var.cp_name}-cluster"
}

resource "aws_ecs_service" "gatling_service" {
  name            = "${var.cp_name}-service"
  cluster         = aws_ecs_cluster.gatling_cluster.id
  task_definition = aws_ecs_task_definition.gatling_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  dynamic "load_balancer" {
    for_each = var.pp_flag ? [1] : []
    content {
      target_group_arn = var.pp_flag ? var.pp_alb_target_group_arn : ""
      container_name   = "control-plane"
      container_port   = 8080
    }
  }

  network_configuration {
    subnets          = var.cp_subnet_ids
    security_groups  = var.cp_security_group_ids
    assign_public_ip = true
  }

  depends_on = [aws_ecs_task_definition.gatling_task]
}