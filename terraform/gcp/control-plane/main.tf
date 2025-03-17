module "iam" {
  source          = "../../gcp/control-plane/modules/iam"
  locations       = var.locations
  private-package = var.private-package
}

module "virtual-machine" {
  source            = "../../gcp/control-plane/modules/virtual-machine"
  name              = var.name
  description       = var.description
  token-secret-name = var.token-secret-name
  service-email     = module.iam.email
  network           = var.network
  compute           = var.compute
  container         = var.container
  locations         = var.locations
  private-package   = var.private-package
  enterprise-cloud  = var.enterprise-cloud
  extra-content     = var.extra-content
}
