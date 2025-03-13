module "iam" {
  source          = "../../gcp/control-plane/modules/iam"
  locations       = var.locations
  private_package = var.private_package
}

module "virtual-machine" {
  source            = "../../gcp/control-plane/modules/virtual-machine"
  name              = var.name
  description       = var.description
  token_secret_name = var.token_secret_name
  service_email     = module.iam.email
  network           = var.network
  compute           = var.compute
  container         = var.container
  locations         = var.locations
  private_package   = var.private_package
  enterprise_cloud  = var.enterprise_cloud
  extra_content     = var.extra_content
}
