provider "aws" {
  region = "eu-west-1"
}

module "location" {
  source             = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/aws/location"
  id                 = "prl_aws"
  region             = "eu-west-1"
  subnet_ids         = ["subnet-a", "subnet-b"]
  security_group_ids = ["sg-id"]
  //instance_type      = "c7i.xlarge"
}

module "control-plane" {
  source             = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/aws/control-plane"
  name               = "name"
  token              = "token"
  subnet_ids         = ["subnet-a", "subnet-b"]
  security_group_ids = ["sg-id"]
  conf_s3_name       = "conf_s3_name"
  locations          = [module.location]
}
