module "storage-account" {
  source               = "./modules/storage-account"
  description          = var.description
  resource-group-name  = var.resource-group-name
  storage-account-name = var.storage-account-name
  locations            = var.locations
  private-package      = var.private-package
  enterprise-cloud     = var.enterprise-cloud
  extra-content        = var.extra-content
}

module "container-app" {
  source              = "./modules/container-app"
  name                = var.name
  secret-id           = var.secret-id
  resource-group-name = var.resource-group-name
  region              = var.region
  container           = var.container
  storage = {
    account-name               = var.storage-account-name
    account-primary-access-key = module.storage-account.primary-access-key
    share-name                 = module.storage-account.share-name
  }
  private-package = var.private-package
}

module "role-assignment" {
  source              = "./modules/role-assignment"
  resource-group-name = var.resource-group-name
  vault-name          = var.vault-name
  container           = module.container-app.container
  private-package     = var.private-package
}
