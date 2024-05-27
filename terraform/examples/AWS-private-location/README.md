# AWS-private-location

This Terraform configuration sets up the AWS infrastructure for Gatling Enterprise's Private Locations deployment. The configuration uses two modules: one for specifying the location and the other for deploying the control plane.

## Prerequisites

- Gatling Enterprise [account](https://auth.gatling.io/auth/realms/gatling/protocol/openid-connect/auth?client_id=gatling-enterprise-cloud-public&response_type=code&scope=openid&redirect_uri=https%3A%2F%2Fcloud.gatling.io%2Fr%2Fgatling) with Private Locations enabled. To access this feature, please contact our [technical support](https://gatlingcorp.atlassian.net/servicedesk/customer/portal/8/group/12/create/59?summary=Private+Locations&description=Contact%20email%3A%20%3Cemail%3E%0A%0AHello%2C%20we%20would%20like%20to%20enable%20the%20private%20locations%20feature%20on%20our%20organization.).
- A control plane [token](https://docs.gatling.io/reference/install/cloud/private-locations/introduction/#token).
- Terraform installed on your local machine
- AWS credentials configured

## Configuration

### Provider

The provider block specifies the AWS region to use:

```sh
provider "aws" {
  region = "eu-west-1"
}
```

## Modules

### Location

This module specifies the location parameters for the control plane, including the subnet IDs and security group IDs.
Ensure that your network permits outbound access to the domains listed in this documentation [link](https://docs.gatling.io/reference/install/cloud/private-locations/introduction/#network).

```sh
module "location" {
  source             = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/aws/location"
  id                 = "prl_aws"
  region             = "eu-west-1"
  subnet_ids         = ["subnet-a", "subnet-b"]
  security_group_ids = ["sg-id"]
}
```

- `source` (required): The source of the module, pointing to the GitHub repository.
- `id` (required): ID of the location.
- `region` (required): The AWS region to deploy to.
- `subnet_ids` (required): List of subnet IDs where the resources will be deployed.
- `security_group_ids` (required): List of security group IDs to be used.
- `description`: Description of the location.
- `instance_type`: Instance type of the location.
- `spot`: Flag to enable spot instances.
- `ami_type`: AMI type of the location.
- `java_version`: Java version of the location.
- `elastic_ips`: Assign elastic IPs to your Locations.
- `profile_name`: Profile name to be assigned to the Location.
- `iam_instance_profile`: IAM instance profile to be assigned to the Location.
- `tags`: Tags to be assigned to the Location.
- `tags_for`: Tags to be assigned to the resources of the Location.
- `system_properties`: System properties to be assigned to the Location.
- `java_home`: Overwrite JAVA_HOME definition.
- `jvm_options`: Overwrite JAVA_HOME definition.

### Control Plane

Sets up the control plane with configurations for networking, security, and S3 storage.

```sh
module "control-plane" {
  source              = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/aws/control-plane"
  name                = "name"
  token               = "token"
  vpc                 = "vpc-id"
  subnet_ids          = ["subnet-a", "subnet-b"]
  security_group_ids  = ["sg-id"]
  conf_s3_name        = "conf_s3_name"
  conf_s3_object_name = "control-plane.conf"
  locations           = [module.location]
}
```

- `source` (required): The source of the module, pointing to the GitHub repository.
- `name` (required): The name of the control plane.
- `token`: The control plane token for authentication.
- `vpc` (required): The VPC ID where the control plane will be deployed.
- `subnet_ids` (required): List of subnet IDs where the resources will be deployed.
- `security_group_ids` (required): List of security group IDs to be used.
- `conf_s3_name` (required): The name of the S3 bucket for configuration.
- `conf_s3_object_name`: The name of the configuration object in the S3 bucket.
- `locations` (required): The list of location module(s).
- `description`: Description of the control plane.
- `image`: Image of the control plane.

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
