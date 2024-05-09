terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.48.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

resource "aws_s3_bucket" "cp_s3_bucket" {
  bucket = "${var.cp_name}-s3"
  tags = {
    Name = "Control Plane Configuration Bucket"
  }
}

resource "aws_s3_object" "cp_config" {
  bucket  = aws_s3_bucket.cp_s3_bucket.id
  key     = "control-plane.conf"
  content = jsonencode({
    control-plane : {
      token : var.cp_token,
      description : "my control plane description",
      locations : [for location in var.locations : {
        id : location.id,
        description : location.description,
        type : "aws",
        region : location.region,
        ami : {
          type : "certified",
          java : location.java_version
        },
        security-groups : location.security_group_ids,
        instance-type : location.instance_type,
        subnets : location.subnet_ids,
        tags : {},
        tags-for : {
          instance : {},
          volume : {},
          network-interface : {}
        },
        system-properties : {},
        #java-home: "/usr/lib/jvm/zulu",
        #jvm-options: ["-Xmx4G", "-Xms512M"]
      }]
    }
  })
  content_type = "application/json"
}

resource "aws_iam_role" "gatling_role" {
  name = "${var.cp_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "s3_policy" {
  name = var.s3_policy_name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject"],
        Resource = "arn:aws:s3:::${var.cp_name}-s3/control-plane.conf"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_policy" {
  name = var.ec2_policy_name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:Describe*",
          "ec2:CreateTags",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:AssociateAddress",
          "ec2:DisassociateAddress"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = aws_iam_role.gatling_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.gatling_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_ecs_task_definition" "gatling_task" {
  family                   = "${var.cp_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.gatling_role.arn
  execution_role_arn       = aws_iam_role.gatling_role.arn
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

  network_configuration {
    subnets          = var.cp_subnet_ids
    security_groups  = var.cp_security_group_ids
    assign_public_ip = true
  }

  depends_on = [aws_ecs_task_definition.gatling_task]
}