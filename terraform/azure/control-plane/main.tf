module "storage-account" {
  source               = "./modules/storage-account"
  description          = var.description
  resource_group_name  = var.resource_group_name
  storage_account_name = var.storage_account_name
  locations            = var.locations
  private_package      = var.private_package
  enterprise_cloud     = var.enterprise_cloud
  extra_content        = var.extra_content
}

module "container-app" {
  source              = "./modules/container-app"
  name                = var.name
  secret_id           = var.secret_id
  resource_group_name = var.resource_group_name
  region              = var.region
  container           = var.container
  storage = {
    account_name               = var.storage_account_name
    account_primary_access_key = module.storage-account.storage_account_primary_access_key
    share_name                 = module.storage-account.storage_share_name
  }
  private_package = var.private_package
}

module "role-assignment" {
  source              = "./modules/role-assignment"
  resource_group_name = var.resource_group_name
  vault_name          = var.vault_name
  container           = module.container-app.container
  private_package     = var.private_package
}
