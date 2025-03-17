provider "azurerm" {
  features {}
}

# Configure a private package (control plane repository & server)
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/private-packages/#gcp-cloud-storage
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/private-packages/#control-plane-server
module "private-package" {
  source               = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/azure/private-package"
  control_plane_name   = "<Name>"
  storage_account_name = "<StorageAccountName>"
}

# Configure a Azure private location
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/azure/configuration/#control-plane-configuration-file
module "location" {
  source       = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/azure/location"
  id           = "prl_<PrivateLocationID>"
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
