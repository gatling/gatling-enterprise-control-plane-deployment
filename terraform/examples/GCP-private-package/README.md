# GCP-private-package

This Terraform configuration sets up the GCP infrastructure for Gatling Enterprise's Private Locations & Private Packages deployment. The configuration uses three modules: one for specifying the location, another for specifying the private package, and a third for deploying the control plane.

## Prerequisites

- Gatling Enterprise [account](https://auth.gatling.io/auth/realms/gatling/protocol/openid-connect/auth?client_id=gatling-enterprise-cloud-public&response_type=code&scope=openid&redirect_uri=https%3A%2F%2Fcloud.gatling.io%2Fr%2Fgatling) with Private Locations enabled. To access this feature, please contact our [technical support](https://gatlingcorp.atlassian.net/servicedesk/customer/portal/8/group/12/create/59?summary=Private+Locations&description=Contact%20email%3A%20%3Cemail%3E%0A%0AHello%2C%20we%20would%20like%20to%20enable%20the%20private%20locations%20feature%20on%20our%20organization.).
- A control plane [token](https://docs.gatling.io/reference/install/cloud/private-locations/introduction/#token).
- Terraform installed on your local machine.
- GCP credentials configured.

## Configuration

### Provider

The provider block specifies the Azure subscription to use:

```sh
provider "google" {
  project = "project-id"
  region  = "europe-west3"
}
```

## Modules

### Private Package

This module specifies the private package parameters for the control plane. It includes the container name and storage account name.

```sh
module "private-package" {
  source  = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/private-package"
  bucket  = "bucket-name"
  project = "project-id"
}
```

- `source` (required): The source of the module, pointing to the GitHub repository.
- `bucket` (required): Storage bucket of the private package
- `project` (required): Project id of the private package storage bucket.

### Location

This module specifies the location parameters for the control plane, including project id and zone.

```sh
module "location" {
  source       = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/location"
  id           = "prl_gcp"
  project      = "project-id"
  zone         = "zone-a"
  machine_type = "c3-highcpu-4"
  engine       = "classic"
}
```

- `source` (required): The source of the module, pointing to the GitHub repository.
- `id` (required): ID of the location.
- `project` (required): Project id where the on-demand load generators will be spawned.
- `zone` (required): The GCP zone to deploy to.
- `machine_type`: VM size for the location.
- `engine`: Engine of the location determining the compatible package formats (JavaScript or JVM).
- `description`: Description of the location.
- `instance_template`: Instance template defining configuration settings for virtual machine.
- `preemptible`: Configure load generators instances as preemptible or not.
- `image_type`: Image type of the location.
- `java_version`: Java version of the location.
- `network_interface`: Network interface properties to be assigned to the Location.
- `system_properties`: System properties to be assigned to the Location.
- `java_home`: Overwrite JAVA_HOME definition.
- `jvm_options`: Overwrite JAVA_HOME definition.

### Control Plane

Sets up the control plane with configurations for networking, security, and storage.

```sh
module "control-plane" {
  source          = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/control-plane"
  name            = "name"
  token           = "token"
  zone            = "zone-a"
  network         = "network"
  locations       = [module.location]
  private_package = module.private-package
}
```

- `source` (required): The source of the module, pointing to the GitHub repository.
- `name` (required): The name of the control plane.
- `token` (required): The control plane token for authentication.
- `zone` (required): The GCP zone to deploy to.
- `network` (Either network or subnetwork must be provided): The name or self_link of the network to be used to attach the VM network interface.
- `subnetwork` (Either network or subnetwork must be provided):  The name or self_link of the subnetwork to be used to attach the VM network interface.
- `locations` (required): The list of location module(s).
- `private_package` (required): The name of the private package module for configuration.
- `enable_external_ip`: Whether to enable external IP for the instance.
- `machine_type`: The machine type to be used for hosting the control plane container.
- `image`: Image of the control plane.
- `description`: Description of the control plane.
- `enable_confidential_compute`: Option to enable confidential compute.
- `confidential_instance_type`: Set a Confidential Instance Type.
- `min_cpu_platform`: Specifies a minimum CPU platform for the VM instance.
- `secret_name`: The name of the configuration secret.
- `secret_location`: Secret replication location.

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
