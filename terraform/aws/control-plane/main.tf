module "iam" {
  source           = "./modules/iam"
  name             = var.name
  token_secret_arn = var.token_secret_arn
  private_package  = var.private_package
  cloudWatch_logs  = var.cloudWatch_logs
  ecr              = var.ecr
}

module "ecs" {
  source                 = "./modules/ecs"
  ecs_tasks_iam_role_arn = module.iam.ecs_tasks_iam_role_arn
  name                   = var.name
  description            = var.description
  subnet_ids             = var.subnet_ids
  security_group_ids     = var.security_group_ids
  image                  = var.image
  command                = var.command
  secrets                = var.secrets
  environment            = var.environment
  locations              = var.locations
  private_package        = var.private_package
  enterprise_cloud       = var.enterprise_cloud
  extra_content          = var.extra_content
  token_secret_arn       = var.token_secret_arn
  cloudWatch_logs        = var.cloudWatch_logs
}
