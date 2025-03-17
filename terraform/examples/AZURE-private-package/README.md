# Azure-private-package

This Terraform configuration sets up the Azure infrastructure for Gatling Enterprise's Private Locations & Private Packages deployment. The configuration uses three modules: one for specifying the location, another for specifying the private package, and a third for deploying the control plane.

## Prerequisites

- Gatling Enterprise [account](https://auth.gatling.io/auth/realms/gatling/protocol/openid-connect/auth?client_id=gatling-enterprise-cloud-public&response_type=code&scope=openid&redirect_uri=https%3A%2F%2Fcloud.gatling.io%2Fr%2Fgatling) with Private Locations enabled. To access this feature, please contact our [technical support](https://gatlingcorp.atlassian.net/servicedesk/customer/portal/8/group/12/create/59?summary=Private+Locations&description=Contact%20email%3A%20%3Cemail%3E%0A%0AHello%2C%20we%20would%20like%20to%20enable%20the%20private%20locations%20feature%20on%20our%20organization.).
- A control plane [token](https://docs.gatling.io/reference/install/cloud/private-locations/introduction/#token) stored in Azure Vault as a secret.
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

### Private Package

This module specifies the private package parameters for the control plane. It includes the container name and storage account name.

```sh
# Configure a private package (control plane repository & server)
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/private-packages/#gcp-cloud-storage
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/private-packages/#control-plane-server
module "private-package" {
  source               = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/azure/private-package"
  control_plane_name   = "<Name>"
  storage_account_name = "<StorageAccountName>"
}
```

### Location

This module specifies the location parameters for the control plane, including resource group, virtual network, and subnet.

```sh
# Configure a Azure private location
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/azure/configuration/#control-plane-configuration-file
module "location" {
  source       = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/azure/location"
  id           = "prl_azure"
  region       = "<Region>"
  subscription = "<SubscriptionUUID>"
  network_id   = "/subscriptions/<SubscriptionUUID>/resourceGroups/<ResourceGroup>/providers/Microsoft.Network/virtualNetworks/<VNet>"
  subnet_name  = "<Subnet>"
  image = {
    type = "certified"
    # java  = "latest"
    # image = "/subscriptions/<SubscriptionUUID>/resourceGroups/<ResourceGroup>/providers/Microsoft.Compute/galleries/customImages/images/<Image>"
  }
  # size                = "Standard_A4_v2"
  # engine              = "classic"
  # associate_public_ip = false
  # tags                = {}
  # system_properties   = {}
  # java_home           = ""
  # jvm_options         = []
  # enterprise_cloud = {
  #   #  Setup the proxy configuration for the private location
  #   #  Reference: https://docs.gatling.io/reference/install/cloud/private-locations/network/#configuring-a-proxy
  # }
}
```

### Control Plane

Sets up the control plane with configurations for networking, security, and storage.

```sh
# Create a control plane based on Azure Container App
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/azure/installation/
module "control-plane" {
  source               = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/azure/control-plane"
  name                 = "<Name>"
  region               = "<Region>"
  resource_group_name  = "<ResourceGroup>"
  vault_name           = "<Vault>"
  secret_id            = "<SecretIdentifier>"
  storage_account_name = "<StorageAccount>"
  # container = {
  #   image   = "gatlingcorp/control-plane:latest"
  #   cpu     = 1.0
  #   memory  = "2Gi"
  #   command = []
  #   env     = []
  # }
  locations       = [module.location]
  private_package = module.private-package
  # enterprise_cloud = {
  #   Setup the proxy configuration for the private location
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
