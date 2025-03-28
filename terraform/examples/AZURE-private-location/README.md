# Azure-private-location

![Gatling-enterprise-logo-RVB](https://github.com/user-attachments/assets/6cd75464-0173-4578-9ad1-b2481cc9b36b)

This Terraform configuration sets up the Azure infrastructure for Gatling Enterprise's Private Locations deployment. The configuration uses two modules: one for specifying the location and the other for deploying the control plane.

![azure-diagram](https://github.com/user-attachments/assets/8bb3b3c8-e39b-4e52-93d8-ea392ed46122)

> [!WARNING]
> These scripts are here to help you bootstrapping your installation.
> They are likely to frequently change in an incompatible fashion.
> Feel free to fork them and adapt them to your needs

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
# Configure a Azure private location
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/azure/configuration/#control-plane-configuration-file
module "location" {
  source       = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/azure/location"
  id           = "prl_azure"
  description  = "Private Location on Azure"
  region       = "westeurope"
  subscription = "<SubscriptionUUID>"
  network-id   = "/subscriptions/<SubscriptionUUID>/resourceGroups/<ResourceGroup>/providers/Microsoft.Network/virtualNetworks/<VNet>"
  subnet-name  = "<Subnet>"
  # image = {
  #   type  = "certified"
  #   java  = "latest"
  #   image = "/subscriptions/<SubscriptionUUID>/resourceGroups/<ResourceGroup>/providers/Microsoft.Compute/galleries/customImages/images/<Image>"
  # }
  # size                = "Standard_A4_v2"
  # engine              = "classic"
  # associate-public-ip = true
  # tags                = {}
  # system_properties   = {}
  # java-home           = "/usr/lib/jvm/zulu"
  # jvm-options         = []
  # enterprise-cloud = {
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
  description          = "My Azure control plane description"
  vault-name           = "<Vault>"
  secret-id            = "<SecretIdentifier>"
  region               = "<Region>"
  resource-group-name  = "<ResourceGroup>"
  storage-account-name = "<StorageAccount>"
  locations            = [module.location]
  # container = {
  #   cpu         = 1.0
  #   memory      = "2Gi"
  #   image       = "gatlingcorp/control-plane:latest"
  #   command     = []
  #   environment = []
  # }
  # enterprise-cloud = {
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
