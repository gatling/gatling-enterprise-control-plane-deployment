module "storage-account" {
  source               = "./modules/storage-account"
  token                = var.token
  description          = var.description
  resource_group_name  = var.resource_group_name
  storage_account_name = var.storage_account_name
  conf_share_file_name = var.conf_share_file_name
  locations            = var.locations
  enterprise_cloud     = var.enterprise_cloud
  private_package      = var.private_package
  extra_content        = var.extra_content
}

module "container-app" {
  source                             = "./modules/container-app"
  name                               = var.name
  image                              = var.image
  resource_group_name                = var.resource_group_name
  region                             = var.region
  storage_account_name               = var.storage_account_name
  storage_account_primary_access_key = module.storage-account.storage_account_primary_access_key
  storage_share_name                 = module.storage-account.storage_share_name
  private_package                    = var.private_package
  command                            = var.command
  enterprise_cloud                   = var.enterprise_cloud
}

module "role-assignment" {
  source          = "./modules/role-assignment"
  container       = module.container-app.container
  private_package = var.private_package
}
