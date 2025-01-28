module "secret-manager" {
  source           = "../../gcp/control-plane/modules/secret-manager"
  name             = var.secret_name
  token            = var.token
  description      = var.description
  enterprise_cloud = var.enterprise_cloud
  locations        = var.locations
  secret_location  = var.secret_location
  private_package  = var.private_package
}

module "service-account" {
  source          = "../../gcp/control-plane/modules/service-account"
  private_package = var.private_package
}

module "virtual-machine" {
  source                      = "../../gcp/control-plane/modules/virtual-machine"
  name                        = var.name
  zone                        = var.zone
  image                       = var.image
  machine_type                = var.machine_type
  network                     = var.network
  subnetwork                  = var.subnetwork
  min_cpu_platform            = var.min_cpu_platform
  enable_confidential_compute = var.enable_confidential_compute
  confidential_instance_type  = var.confidential_instance_type
  enable_external_ip          = var.enable_external_ip
  secret_name                 = module.secret-manager.secret_name
  service_email               = module.service-account.email
  private_package             = var.private_package
}
