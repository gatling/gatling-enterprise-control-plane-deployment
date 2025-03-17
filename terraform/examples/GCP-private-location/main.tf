provider "google" {
  project = "<ProjectId>"
  region  = "<Region>"
}

# Configure a GCP private location
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/gcp/configuration/#control-plane-configuration-file
module "location" {
  source            = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/location"
  id                = "prl_gcp"
  project           = "<ProjectId>"
  zone              = "<Zone>"
  instance-template = "<InstanceTemplate>"
  machine = {
    type = "c3-highcpu-4"
    # preemptible = false
    engine = "classic"
    image = {
      type = "certified"

      
      # java    = "latest"
      # project = "<ProjectName>"
      # family  = "<ImageFamily>"
      # id      = "<ImageId>"
    }
    disk = {
      sizeGb = 20
    }
    # network-interface = {
    #   network          = "<Network>"
    #   subnetwork       = "<SubNetwork>"
    #   with-external-ip = true
    # }
  }
  # system-properties = {}
  # java-home = "/usr/lib/jvm/zulu"
  # jvm-options = ["-Xmx4G", "-Xms512M"]
  # enterprise-cloud = {
  #   Setup the proxy configuration for the private location
  #   Reference: https://docs.gatling.io/reference/install/cloud/private-locations/network/#configuring-a-proxy
  # }
}

# Create a control plane based on GCP VM
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/gcp/installation/
module "control-plane" {
  source            = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/control-plane"
  name              = "name"
  token-secret-name = "<TokenSecretName>"
  network = {
    zone    = "<Zone>"
    network = "<Network>"
    # subnetwork         = "<SubNetwork>"
    enable-external-ip = true
  }
  locations       = [module.location]
  # container = {
  #   image   = "gatlingcorp/control-plane:latest"
  #   command = []
  #   env     = []
  # }
  # enterprise-cloud = {
  #   Setup the proxy configuration for the private location
  #   Reference: https://docs.gatling.io/reference/install/cloud/private-locations/network/#configuring-a-proxy
  # }
}
