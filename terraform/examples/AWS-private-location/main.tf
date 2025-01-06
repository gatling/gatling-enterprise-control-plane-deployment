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
  //engine             = "classic"
  //enterprise_cloud = {
    //url = ""  // http://private-control-plane-forward-proxy/gatling
  //}
}

module "control-plane" {
  source             = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/aws/control-plane"
  name               = "control-plane"
  token_secret_arn   = "aws-secrets-manager-secret-arn"
  subnet_ids         = ["subnet-a", "subnet-b"]
  security_group_ids = ["sg-id"]
  locations          = [module.location]
  //cloudWatch_logs    = true
  //ecr                = false
  //enterprise_cloud = {
    //url = ""  // http://private-control-plane-forward-proxy/gatling
  //}
}
