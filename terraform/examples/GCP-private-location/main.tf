provider "google" {
  project = "project-id"
  region  = "europe-west3"
}

# Configure a GCP private location
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/gcp/configuration/#control-plane-configuration-file
module "location" {
  source  = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/location"
  id      = "prl_gcp"
  project = "project-id"
  zone    = "europe-west3-a"
  machine = {
    type = "c3-highcpu-4"
    # preemptible = false
    engine = "classic"
    image = {
      type = "certified"
      # java    = "latest"
      # project = "gatling-enterprise"
      # family  = "gatling-enterprise"
      # id      = "gatling-enterprise"
    }
    disk = {
      sizeGb = 20
    }
  }
  # enterprise_cloud = {
  #   Setup the proxy configuration for the private location
  #   Reference: https://docs.gatling.io/reference/install/cloud/private-locations/network/#configuring-a-proxy
  # }
}

# Create a control plane based on GCP VM
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/gcp/installation/
module "control-plane" {
  source            = "git::git@github.com:gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/control-plane"
  name              = "name"
  token_secret_name = "token_secret_name"
  network = {
    zone    = "europe-west3-a"
    network = "network"
    # subnetwork         = "subnetwork"
    enable_external_ip = true
  }
  locations = [module.location]
  # container = {
  #   image   = "gatlingcorp/control-plane:latest"
  #   command = []
  #   env     = []
  # }
  # enterprise_cloud = {
  #   Setup the proxy configuration for the private location
  #   Reference: https://docs.gatling.io/reference/install/cloud/private-locations/network/#configuring-a-proxy
  # }
}
