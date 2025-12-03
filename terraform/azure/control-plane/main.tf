module "storage-account" {
  source               = "./modules/storage-account"
  count                = length(var.git.ssh.storage-account-name) > 0 ? 1 : 0
  resource-group-name  = var.resource-group-name
  storage-account-name = var.git.ssh.storage-account-name
}

module "container-app" {
  source              = "./modules/container-app"
  name                = var.name
  description         = var.description
  token-secret-id     = var.token-secret-id
  resource-group-name = var.resource-group-name
  region              = var.region
  container-app       = var.container-app
  git = length(var.git.ssh.storage-account-name) > 0 ? merge(var.git, {
    ssh = merge(var.git.ssh, {
      account-primary-access-key = module.storage-account[0].primary_access_key
    })
  }) : var.git
  locations        = var.locations
  private-package  = var.private-package
  server           = var.server
  enterprise-cloud = var.enterprise-cloud
  extra-content    = var.extra-content
}

module "role-assignment" {
  source              = "./modules/role-assignment"
  resource-group-name = var.resource-group-name
  vault-name          = var.vault-name
  container           = module.container-app.container
  storage             = length(var.git.ssh.storage-account-name) > 0
  private-package     = var.private-package
}
