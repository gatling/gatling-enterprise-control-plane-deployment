module "iam" {
  source          = "../../gcp/control-plane/modules/iam"
  locations       = var.locations
  private_package = var.private_package
}

module "virtual-machine" {
  source                      = "../../gcp/control-plane/modules/virtual-machine"
  name                        = var.name
  description                 = var.description
  zone                        = var.zone
  network                     = var.network
  subnetwork                  = var.subnetwork
  machine_type                = var.machine_type
  min_cpu_platform            = var.min_cpu_platform
  enable_confidential_compute = var.enable_confidential_compute
  confidential_instance_type  = var.confidential_instance_type
  enable_external_ip          = var.enable_external_ip
  image                       = var.image
  token_secret_name           = var.token_secret_name
  service_email               = module.iam.email
  locations                   = var.locations
  enterprise_cloud            = var.enterprise_cloud
  private_package             = var.private_package
  extra_content               = var.extra_content
}
