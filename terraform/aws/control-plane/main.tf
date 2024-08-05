module "iam" {
  source          = "./modules/iam"
  name            = "${var.name}-role"
  s3_bucket_name  = var.conf_s3_name
  private_package = var.private_package
}

module "s3" {
  source          = "./modules/s3"
  name            = var.conf_s3_name
  object_name     = var.conf_s3_object_name
  token           = var.token
  description     = var.description
  locations       = var.locations
  private_package = var.private_package
  extra_content   = var.extra_content
}

module "ecs" {
  source                 = "./modules/ecs"
  name                   = var.name
  image                  = var.image
  subnet_ids             = var.subnet_ids
  security_group_ids     = var.security_group_ids
  conf_s3_name           = var.conf_s3_name
  ecs_tasks_iam_role_arn = module.iam.ecs_tasks_iam_role_arn
  private_package        = var.private_package
  command                = var.command
}
