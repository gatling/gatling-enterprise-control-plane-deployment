provider "azurerm" {
  features {}
}

# Configure a private package (control plane repository & server)
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/private-packages/#gcp-cloud-storage
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/private-packages/#control-plane-server
module "private-package" {
  source               = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/azure/private-package"
  control-plane-name   = "<Name>"
  storage-account-name = "<StorageAccountName>"
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
  source               = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/azure/control-plane"
  name                 = "<Name>"
  vault-name           = "<Vault>"
  secret-id            = "<SecretIdentifier>"
  region               = "<Region>"
  resource-group-name  = "<ResourceGroup>"
  storage-account-name = "<StorageAccount>"
  locations            = [module.location]
  private-package      = module.private-package
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
