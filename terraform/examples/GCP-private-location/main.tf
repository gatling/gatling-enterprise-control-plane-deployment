provider "google" {
  project = "project-id"
  region  = "europe-west3"
}

module "location" {
  source       = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/location"
  id           = "prl_gcp"
  project      = "project-id"
  zone         = "zone-a"
  //machine_type = "c3-highcpu-4"
  //engine       = "classic"
  //enterprise_cloud = {
    //url = "" // http://private-location-forward-proxy/gatling
  //}
}

module "control-plane" {
  source            = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/control-plane"
  name              = "name"
  token_secret_name = "token_secret_name"
  zone              = "zone-a"
  network           = "network"
  locations         = [module.location]
  //enterprise_cloud = {
  //url = ""  // http://private-control-plane-forward-proxy/gatling
  //}
}
