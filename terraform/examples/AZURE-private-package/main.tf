provider "azurerm" {
  features {}
}

module "private-package" {
  source               = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/azure/private-package"
  container_name       = "gatling-cp"
  storage_account_name = "storage-account-name"
}

module "location" {
  source              = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/azure/location"
  id                  = "prl_azure"
  region              = "westeurope"
  resource_group_name = "resource-group-name"
  virtual_network     = "vpc-id"
  subnet_name         = "default"
  //size                = "Standard_A4_v2"
}

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