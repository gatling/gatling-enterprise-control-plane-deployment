data "aws_caller_identity" "current" {}

data "aws_eip" "by_ip" {
  for_each = toset(flatten([
    for location in var.locations : location.conf.elastic-ips
  ]))
  public_ip = each.key
}

locals {
  static_ec2_statements = [
    {
      Sid    = "AllowEC2CreateRunTags"
      Effect = "Allow"
      Action = ["ec2:CreateTags", "ec2:RunInstances"]
      Resource = [
        "arn:aws:ec2:*:*:instance/*",
        "arn:aws:ec2:*:*:network-interface/*",
        "arn:aws:ec2:*:*:security-group/*",
        "arn:aws:ec2:*:*:subnet/*",
        "arn:aws:ec2:*:*:volume/*",
        "arn:aws:ec2:*:*:image/*"
      ]
    },
    {
      Sid      = "EnforceGatlingTag"
      Effect   = "Deny"
      Action   = "ec2:RunInstances"
      Resource = "arn:aws:ec2:*:*:instance/*"
      Condition = {
        StringNotLike = { "aws:RequestTag/Name" = "GATLING_LG_*" }
      }
    },
    {
      Sid      = "AllowTerminateTaggedInstances"
      Effect   = "Allow"
      Action   = "ec2:TerminateInstances"
      Resource = "arn:aws:ec2:*:*:instance/*"
      Condition = {
        StringLike = { "aws:ResourceTag/Name" = "GATLING_LG_*" }
      }
    },
    {
      Sid      = "AllowEC2Describe"
      Effect   = "Allow"
      Action   = ["ec2:DescribeImages", "ec2:DescribeInstances"]
      Resource = "*"
    }
  ]

  elastic_ip_statements_extra = distinct(flatten([
    for location in var.locations : [
      for elastic_ip in location.conf.elastic-ips : {
        Sid    = "AllowElasticIP${replace(data.aws_eip.by_ip[elastic_ip].id, "-", "")}"
        Effect = "Allow"
        Action = [
          "ec2:AssociateAddress",
          "ec2:DisassociateAddress",
        ]
        Resource = "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:address/${data.aws_eip.by_ip[elastic_ip].id}"
      }
    ]
  ]))

  elastic_ip_statements_base = [
    {
      Sid      = "AllowElasticIPAssociateTaggedInstances"
      Effect   = "Allow"
      Action   = ["ec2:AssociateAddress", "ec2:DisassociateAddress"]
      Resource = "arn:aws:ec2:*:*:instance/*"
      Condition = {
        StringLike = { "ec2:ResourceTag/Name" = "GATLING_LG_*" }
      }
    },
    {
      Sid      = "AllowElasticIPDescribe"
      Effect   = "Allow"
      Action   = "ec2:DescribeAddresses"
      Resource = "*"
    }
  ]

  iam_profile_name_statements = distinct([
    for location in var.locations : {
      Sid      = "AllowPassRole_${location.conf.iam-instance-profile}"
      Effect   = "Allow"
      Action   = "iam:PassRole"
      Resource = "arn:aws:iam:${data.aws_caller_identity.current.account_id}:role/${location.conf.iam-instance-profile}"
    }
    if location.conf.iam-instance-profile != null
  ])

  elastic_ip_statements = flatten([
    length(local.elastic_ip_statements_extra) > 0
    ? [local.elastic_ip_statements_base]
    : [],
    [local.elastic_ip_statements_extra],
  ])

  iam_ec2_policy_statements = concat(
    local.static_ec2_statements,
    local.elastic_ip_statements,
    local.iam_profile_name_statements
  )
}

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
    Version   = "2012-10-17",
    Statement = local.iam_ec2_policy_statements
  })
}

resource "aws_iam_policy" "package_s3_policy" {
  count = length(var.private-package) > 0 ? 1 : 0
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
        Resource = "arn:aws:s3:::${var.private-package.conf.bucket}/*"
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
        Resource = var.token-secret-arn
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
  count = var.cloudwatch-logs ? 1 : 0
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
  count      = length(var.private-package) > 0 ? 1 : 0
  role       = aws_iam_role.gatling_role.name
  policy_arn = aws_iam_policy.package_s3_policy[0].arn
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy_attachment" {
  count      = var.cloudwatch-logs ? 1 : 0
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
