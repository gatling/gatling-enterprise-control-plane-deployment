resource "aws_iam_role" "gatling_role" {
  name = var.name
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
  name = "${var.name}-ConfInitContainerPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:GetObject"],
        Resource = "arn:aws:s3:::${var.s3_bucket_name}/control-plane.conf"
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_policy" {
  name = "${var.name}-EC2Policy"
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

resource "aws_iam_policy" "pp_s3_policy" {
  count = length(var.private_package) > 0 ? 1 : 0
  name  = "${var.name}-PackagePolicy"
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

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  count = var.cloudWatch_logs ? 1 : 0
  name  = "${var.name}-CloudWatchLogsPolicy"
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

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = aws_iam_role.gatling_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.gatling_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_role_policy_attachment" "pp_s3_policy_attachment" {
  count      = length(var.private_package) > 0 ? 1 : 0
  role       = aws_iam_role.gatling_role.name
  policy_arn = aws_iam_policy.pp_s3_policy[0].arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy_attachment" {
  count      = var.cloudWatch_logs ? 1 : 0
  role       = aws_iam_role.gatling_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy[0].arn
}