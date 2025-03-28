provider "aws" {
  region = "<Region>"
}

# Configure a AWS private location
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/aws/configuration/#control-plane-configuration-file
module "location" {
  source          = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/aws/location"
  id              = "prl_aws"
  description     = "Private Location on AWS"
  region          = "<Region>"
  subnets         = ["<SubnetId>"]
  security-groups = ["<SecurityGroupId>"]
  # instance-type   = "c7i.xlarge"
  # engine          = "classic"
  # ami = {
  #   type = "certified"
  #   java = "latest"
  #   id   = "ami-00000000000000000"
  # }
  # spot                       = false
  # auto-associate-public-ipv4 = true
  # elastic-ips                = ["203.0.113.3", "203.0.113.4"]
  # profile-name               = "profile-name"
  # iam-instance-profile = "iam-instance-profile"
  # tags                       = {}
  # tags-for = {
  #   instance          = {}
  #   volume            = {}
  #   network-interface = {}
  # }
  # system-properties   = {}
  # java-home           = "/usr/lib/jvm/zulu"
  # jvm-options         = []
  # enterprise-cloud = {
  #   Setup the proxy configuration for the private location
  #   Reference: https://docs.gatling.io/reference/install/cloud/private-locations/network/#configuring-a-proxy
  # }
}

# Create a control plane based on AWS ECS
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/aws/installation/
module "control-plane" {
  source           = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/aws/control-plane"
  name             = "<Name>"
  description      = "My AWS control plane description"
  token-secret-arn = "<TokenSecretARN>"
  subnets          = ["<SubnetId>"]
  security-groups  = ["<SecurityGroupId>"]
  locations        = [module.location]
  # task = {
  #   cpu             = "1024"
  #   memory          = "3072"
  #   image           = "gatlingcorp/control-plane:latest"
  #   command         = []
  #   secrets         = []
  #   environment     = []
  #   cloudwatch-logs = true
  #   ecr             = false
  # }
  # enterprise-cloud = {
  #   Setup the proxy configuration for the control plane
  #   Reference: https://docs.gatling.io/reference/install/cloud/private-locations/network/#configuring-a-proxy
  # }
}
