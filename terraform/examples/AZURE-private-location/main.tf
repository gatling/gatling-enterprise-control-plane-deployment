provider "azurerm" {
  features {}
}

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

# Create a control plane based on Azure Container App
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/azure/installation/
module "control-plane" {
  source              = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/azure/control-plane"
  name                = "<Name>"
  description         = "My Azure control plane description"
  vault-name          = "<Vault>"
  token-secret-id     = "<TokenSecretIdentifier>"
  region              = "<Region>"
  resource-group-name = "<ResourceGroup>"
  locations           = [module.location]
  # container-app = {
  #   init = {
  #     image = "busybox"
  #   }
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
