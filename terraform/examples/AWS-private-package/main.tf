provider "aws" {
  region = "eu-west-3"
}

# Configure a private package (control plane repository & server) based on AWS S3
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/private-packages/#aws-s3
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/private-packages/#control-plane-server
module "private-package" {
  source = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/aws/private-package"
  bucket = "<S3BucketName>"
  # path    = ""
  # upload = {
  #   directory = "/tmp"
  # }
  # server = {
  #   port        = 8080
  #   bindAddress = "0.0.0.0"
  #   certificate = {
  #     path     = "/path/to/certificate.p12"
  #     password = "password"
  #   }
  # }
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
  private-package  = module.private-package
  # extra-init-command     = "mkdir /app/conf/.aws && echo -e \"[profile_name]\naws_access_key_id = $AWS_ACCESS_KEY_ID\naws_secret_access_key = $AWS_SECRET_KEY\n\" > /app/conf/.aws/credentials"
  # task = {
  #   cpu             = "1024"
  #   memory          = "3072"
  #   init = {
  #     image = "busybox"
  #   }
  #   image           = "gatlingcorp/control-plane:latest"
  #   command         = []
  #   secrets         = []
  #   environment     = []
  #   cloudwatch-logs = true
  #   ecr             = false
  # }
  # git = {
  #   Configure git credentials for the control plane. Requires builder image: "gatlingcorp/control-plane:latest-builder"
  #   Reference: https://docs.gatling.io/reference/execute/cloud/user/build-from-sources/
  #   host = "github.com"
  #   credentials = {
  #     username         = "<GitUsername>"
  #     token-secret-arn = "<GitTokenSecretARN>"
  #   }
  #   ssh = {
  #     private-key-secret-arn = "<GitSSHPrivateKeySecretARN>"
  #   }
  #   cache = {
  #     paths = ["/app/.m2", "/app/.gradle", "/app/.sbt", "/app/.npm"]
  #   }
  # }
  # enterprise-cloud = {
  #   Setup the proxy configuration for the control plane
  #   Reference: https://docs.gatling.io/reference/install/cloud/private-locations/network/#configuring-a-proxy
  # }
}
