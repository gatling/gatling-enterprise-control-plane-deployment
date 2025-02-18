# Azure-private-location

This Terraform configuration sets up the Azure infrastructure for Gatling Enterprise's Private Locations deployment. The configuration uses two modules: one for specifying the location and the other for deploying the control plane.

## Prerequisites

- Gatling Enterprise [account](https://auth.gatling.io/auth/realms/gatling/protocol/openid-connect/auth?client_id=gatling-enterprise-cloud-public&response_type=code&scope=openid&redirect_uri=https%3A%2F%2Fcloud.gatling.io%2Fr%2Fgatling) with Private Locations enabled. To access this feature, please contact our [technical support](https://gatlingcorp.atlassian.net/servicedesk/customer/portal/8/group/12/create/59?summary=Private+Locations&description=Contact%20email%3A%20%3Cemail%3E%0A%0AHello%2C%20we%20would%20like%20to%20enable%20the%20private%20locations%20feature%20on%20our%20organization.).
- A control plane [token](https://docs.gatling.io/reference/install/cloud/private-locations/introduction/#token) stored in Azure Vault as a secret.
- A storage account to be mounted as a container volume.
- Terraform installed on your local machine.
- Azure credentials configured.

## Configuration

### Provider

The provider block specifies the Azure subscription to use:

```sh
provider "azurerm" {
  features {}
}
```

## Modules

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
  size                = "Standard_A4_v2"
  engine              = "classic"
  //enterprise_cloud    = {
    //url = ""  // http://private-location-forward-proxy/gatling
  //}
}
```

- `source` (required): The source of the module, pointing to the GitHub repository.
- `id` (required): ID of the location.
- `region` (required): The Azure region to deploy to.
- `resource_group_name` (required): The name of the resource group.
- `virtual_network` (required): The name of the virtual network to deploy resources into.
- `subnet_name` (required): The name of the subnet within the virtual network.
- `size`: VM size for the location.
- `engine`: Engine of the location determining the compatible package formats (JavaScript or JVM).
- `associate_public_ip`: Boolean to associate a public IP to your load generator.
- `description`: Description of the location.
- `system_properties`: System properties to be assigned to the Location.
- `java_home`: Overwrite JAVA_HOME definition.
- `jvm_options`: Overwrite JAVA_HOME definition.
- `enterprise_cloud.url`: Set up a forward proxy for the control plane.

### Control Plane

Sets up the control plane with configurations for networking, security, and storage.

```sh
module "control-plane" {
  source               = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/azure/control-plane"
  name                 = "gatling-cp"
  region               = "westeurope"
  resource_group_name  = "resource-group-name"
  vault_name           = "vault-name"
  secret_id            = "token-secret-identifier"
  storage_account_name = "storage-account-name"
  locations            = [module.location]
  //enterprise_cloud    = {
    //url = ""  // http://private-control-plane-forward-proxy/gatling
  //}
}
```

- `source` (required): The source of the module, pointing to the GitHub repository.
- `name` (required): The name of the control plane.
- `region` (required): The Azure region to deploy to.
- `resource_group_name` (required): The name of the resource group where the control plane will be deployed.
- `vault_name`(required): Vault name where the control plane secret token is stored.
- `secret_id`(required): Secret identifier for the stored control plane token.
- `storage_account_name` (required): The storage account name where configurations will be stored.
- `locations` (required): The list of location module(s).
- `image`: Image of the control plane.
- `description`: Description of the control plane.
- `conf_share_file_name`: The name of the configuration object in the file share.
- `container_cpu`: Control Plane container CPU allocation.
- `container_memory`: Control Plane container memory allocation.
- `enterprise_cloud.url`: Set up a forward proxy for the control plane.

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
