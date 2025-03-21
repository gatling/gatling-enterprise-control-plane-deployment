module "iam" {
  source           = "./modules/iam"
  name             = var.name
  token-secret-arn = var.token-secret-arn
  private-package  = var.private-package
  cloudwatch-logs  = var.task.cloudwatch-logs
  ecr              = var.task.ecr
}

module "ecs" {
  source           = "./modules/ecs"
  name             = var.name
  description      = var.description
  subnets          = var.subnets
  security-groups  = var.security-groups
  token-secret-arn = var.token-secret-arn
  task = merge(
    var.task,
    { iam-role-arn = module.iam.task-role-arn }
  )
  locations        = var.locations
  private-package  = var.private-package
  enterprise-cloud = var.enterprise-cloud
  extra-content    = var.extra-content
}
