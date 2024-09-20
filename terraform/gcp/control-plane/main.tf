module "secret-manager" {
  source          = "../../gcp/control-plane/modules/secret-manager"
  token           = var.token
  description     = var.description
  locations       = var.locations
  private_package = var.private_package
}

module "service-account" {
  source          = "../../gcp/control-plane/modules/service-account"
  private_package = var.private_package
}

module "virtual-machine" {
  source          = "../../gcp/control-plane/modules/virtual-machine"
  name            = var.name
  zone            = var.zone
  image           = var.image
  secret_name     = module.secret-manager.secret_name
  service_email   = module.service-account.email
  private_package = var.private_package
}