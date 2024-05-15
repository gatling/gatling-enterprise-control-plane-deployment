module "iam" {
  source = "./iam"
  name = "${var.name}-role"
  s3_bucket_name = var.conf_s3_name
  private_package =  var.private_package
}

module "s3" {
  source = "./s3"
  name = var.conf_s3_name
  object_name = var.conf_s3_object_name
  token = var.token
  locations = var.locations
  private_package = var.private_package
}

module "alb" {
  source = "./alb"
  name = "${var.name}-alb"
  vpc = var.vpc
  security_group_ids = var.alb_security_group_ids
  subnet_ids = var.subnet_ids
  private_package = var.private_package
}

module "ecs" {
  source = "./ecs"
  name = var.name
  subnet_ids = var.subnet_ids
  security_group_ids = var.security_group_ids
  conf_s3_name = var.conf_s3_name
  ecs_tasks_iam_role_arn =  module.iam.ecs_tasks_iam_role_arn
  private_package = var.private_package
  alb_security_group_ids = var.alb_security_group_ids
  alb_target_group_arn = module.alb.target_group_arn
}