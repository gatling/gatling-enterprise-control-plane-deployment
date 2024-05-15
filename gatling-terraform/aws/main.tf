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

module "control-plane" {
  source                 = "./modules/control-plane"
  name                   = "gatling-cp"
  token                  = var.token
  vpc                    = var.vpc
  subnet_ids             = var.subnet_ids
  security_group_ids     = var.security_group_ids
  alb_security_group_ids = var.alb_security_group_ids
  conf_s3_name           = var.conf_s3_name
  locations              = [module.location]
  //private_package        = module.private-package       // Uncomment to enable Private Package feature
}

module "location" {
  source             = "./modules/location"
  id                 = "prl_aws"
  description        = var.location_description
  java_version       = var.location_java_version
  instance_type      = var.location_instance_type
  region             = var.region
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
}

/*module "private-package" {                              // Uncomment to enable Private Package feature
  source     = "./modules/private-package"
  bucket = var.package_name
  path  = var.package_path
}*/