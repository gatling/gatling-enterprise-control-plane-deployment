resource "aws_iam_role" "gatling_role" {
  name = "${var.name}-role"
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

resource "aws_iam_policy" "ec2_policy" {
  name = "${var.name}-ec2-policy"
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

resource "aws_iam_policy" "package_s3_policy" {
  count = length(var.private_package) > 0 ? 1 : 0
  name  = "${var.name}-package-s3-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
        ],
        Effect   = "Allow",
        Resource = "arn:aws:s3:::${var.private_package.conf.bucket}/*"
      }
    ]
  })
}

resource "aws_iam_policy" "asm_policy" {
  name = "${var.name}-asm-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = var.token_secret_arn
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_policy" {
  count = var.ecr ? 1 : 0
  name  = "${var.name}-ecr-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  count = var.cloudWatch_logs ? 1 : 0
  name  = "${var.name}-cloudwatch-logs-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.gatling_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_role_policy_attachment" "package_s3_policy_attachment" {
  count      = length(var.private_package) > 0 ? 1 : 0
  role       = aws_iam_role.gatling_role.name
  policy_arn = aws_iam_policy.package_s3_policy[0].arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy_attachment" {
  count      = var.cloudWatch_logs ? 1 : 0
  role       = aws_iam_role.gatling_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy[0].arn
}

resource "aws_iam_role_policy_attachment" "asm_policy_attachment" {
  role       = aws_iam_role.gatling_role.name
  policy_arn = aws_iam_policy.asm_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  count      = var.ecr ? 1 : 0
  role       = aws_iam_role.gatling_role.name
  policy_arn = aws_iam_policy.ecr_policy[0].arn
}
