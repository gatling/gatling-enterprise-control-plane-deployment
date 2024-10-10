provider "google" {
  project = "project-id"
  region  = "europe-west3"
}

module "private-package" {
  source  = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/private-package"
  bucket  = "bucket-name"
  project = "project-id"
}

module "location" {
  source  = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/location"
  id      = "prl_gcp"
  project = "project-id"
  zone    = "zone-a"
  //machine_type = "c3-highcpu-4"
  //engine       = "classic"
}

module "control-plane" {
  source          = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/control-plane"
  name            = "name"
  token           = "token"
  zone            = "zone-a"
  network         = "network"
  locations       = [module.location]
  private_package = module.private-package
}
