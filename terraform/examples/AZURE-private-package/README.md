# Azure-private-package

This Terraform configuration sets up the Azure infrastructure for Gatling Enterprise's Private Locations & Private Packages deployment. The configuration uses three modules: one for specifying the location, another for specifying the private package, and a third for deploying the control plane.

## Prerequisites

- Gatling Enterprise [account](https://auth.gatling.io/auth/realms/gatling/protocol/openid-connect/auth?client_id=gatling-enterprise-cloud-public&response_type=code&scope=openid&redirect_uri=https%3A%2F%2Fcloud.gatling.io%2Fr%2Fgatling) with Private Locations enabled. To access this feature, please contact our [technical support](https://gatlingcorp.atlassian.net/servicedesk/customer/portal/8/group/12/create/59?summary=Private+Locations&description=Contact%20email%3A%20%3Cemail%3E%0A%0AHello%2C%20we%20would%20like%20to%20enable%20the%20private%20locations%20feature%20on%20our%20organization.).
- A control plane [token](https://docs.gatling.io/reference/install/cloud/private-locations/introduction/#token).
- Terraform installed on your local machine.
- Azure credentials configured.

## Configuration

### Provider

The provider block specifies the Azure subscription to use:

```sh
provider "azurerm" {
  features {}
  subscription_id = "subscription-id"
}
```

## Modules

### Private Package

This module specifies the private package parameters for the control plane. It includes the container name and storage account name.

```sh
module "private-package" {
  source               = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/azure/private-package"
  container_name       = "gatling-cp"
  storage_account_name = "storage-account-name"
}
```

- `source` (required): The source of the module, pointing to the GitHub repository.
- `container_name` (required): The name of the control plane.
- `storage_account_name` (required): SThe name of the storage account where the private package will be stored.

### Location

This module specifies the location parameters for the control plane, including resource group, virtual network, and subnet.

```sh
module "location" {
  source              = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/azure/location"
  id                  = "prl_azure"
  region              = "westeurope"
  resource_group_name = "resource-group-name"
  virtual_network     = "vnet-name"
  subnet_name         = "default"
}
```

- `source` (required): The source of the module, pointing to the GitHub repository.
- `id` (required): ID of the location.
- `region` (required): The Azure region to deploy to.
- `resource_group_name` (required): The name of the resource group.
- `virtual_network` (required): The name of the virtual network to deploy resources into.
- `subnet_name` (required): The name of the subnet within the virtual network.
- `description`: Description of the location.
- `size`: VM size for the location.
- `associate_public_ip`: Boolean to associate a public IP to your load generator.
- `system_properties`: System properties to be assigned to the Location.
- `java_home`: Overwrite JAVA_HOME definition.
- `jvm_options`: Overwrite JAVA_HOME definition.

### Control Plane

Sets up the control plane with configurations for networking, security, and storage.

```sh
module "control-plane" {
  source               = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/azure/control-plane"
  name                 = "gatling-cp"
  token                = "token"
  region               = "westeurope"
  resource_group_name  = "resource-group-name"
  storage_account_name = "storage-account-name"
  locations            = [module.location]
  private_package      = module.private-package
}
```

- `source` (required): The source of the module, pointing to the GitHub repository.
- `name` (required): The name of the control plane.
- `token` (required): The control plane token for authentication.
- `region` (required): The Azure region to deploy to.
- `resource_group_name` (required): The name of the resource group where the control plane will be deployed.
- `storage_account_name` (required): The storage account name where configurations will be stored.
- `locations` (required): The list of location module(s).
- `private_package` (required): The name of the private package module for configuration.

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
