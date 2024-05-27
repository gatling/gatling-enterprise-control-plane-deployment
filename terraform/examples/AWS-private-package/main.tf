provider "aws" {
  region = "eu-west-1"
}

module "private-package" {
  source = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/aws/private-package"
  bucket = "bucket"
}

module "location" {
  source             = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/aws/location"
  id                 = "prl_aws"
  region             = "eu-west-1"
  subnet_ids         = ["subnet-a", "subnet-b"]
  security_group_ids = ["sg-id"]
  //instance_type      = "c6i.xlarge"
}

module "control-plane" {
  source                 = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/aws/control-plane"
  name                   = "name"
  token                  = "token"
  vpc                    = "vpc-id"
  subnet_ids             = ["subnet-a", "subnet-b"]
  security_group_ids     = ["sg-id"]
  conf_s3_name           = "conf_s3_name"
  conf_s3_object_name    = "control-plane.conf"
  locations              = [module.location]
  alb_security_group_ids = ["sg-id"]
  private_package        = module.private-package
}
