# AWS-private-package

This Terraform configuration sets up the AWS infrastructure for Gatling Enterprise's Private Locations & Private Packages deployment. The configuration uses three modules: one for specifying the location, second for specifying the private package, and the third for deploying the control plane.

## Prerequisites

- Gatling Enterprise [account](https://auth.gatling.io/auth/realms/gatling/protocol/openid-connect/auth?client_id=gatling-enterprise-cloud-public&response_type=code&scope=openid&redirect_uri=https%3A%2F%2Fcloud.gatling.io%2Fr%2Fgatling) with Private Locations enabled. To access this feature, please contact our [technical support](https://gatlingcorp.atlassian.net/servicedesk/customer/portal/8/group/12/create/59?summary=Private+Locations&description=Contact%20email%3A%20%3Cemail%3E%0A%0AHello%2C%20we%20would%20like%20to%20enable%20the%20private%20locations%20feature%20on%20our%20organization.).
- A control plane [token](https://docs.gatling.io/reference/install/cloud/private-locations/introduction/#token) stored in AWS Secrets Manager as a plaintext secret.
- Terraform installed on your local machine
- AWS credentials configured

## Configuration

### Provider

The provider block specifies the AWS region to use:

```sh
provider "aws" {
  region = "<Region>"
}
```

## Modules

### Private Package

This module specifies the private package parameters for the control plane. It includes the bucket name and other optional inputs.

```sh
# Configure a private package (control plane repository & server) based on AWS S3
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/private-packages/#aws-s3
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/private-packages/#control-plane-server
module "private-package" {
  source = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/aws/private-package"
  bucket = "<S3BucketName>"
}
```

### Location

This module specifies the location parameters for the control plane, including the subnet IDs and security group IDs.
Ensure that your network permits outbound access to the domains listed in this documentation [link](https://docs.gatling.io/reference/install/cloud/private-locations/introduction/#network).

```sh
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
```

### Control Plane

Sets up the control plane with configurations for networking, security, and S3 storage.

```sh
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
```

## Usage

1. Initialize Terraform

```console
terraform init
```

2. Validate the configuration

```console
terraform plan
```

3. Apply the configuration

```console
terraform apply
```
