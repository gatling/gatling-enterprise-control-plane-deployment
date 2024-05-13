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

resource "aws_iam_policy" "pp_s3_policy" {
  count = var.pp_flag ? 1 : 0
  name  = var.pp_s3_policy_name
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
        Resource = "arn:aws:s3:::${var.cp_name}-s3/*"
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
  count      = var.pp_flag ? 1 : 0
  role       = aws_iam_role.gatling_role.name
  policy_arn = aws_iam_policy.pp_s3_policy[0].arn
}