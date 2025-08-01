provider "google" {
  project = "<ProjectId>"
  region  = "<Region>"
}

# Configure a GCP private location
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/gcp/configuration/#control-plane-configuration-file
module "location" {
  source      = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/location"
  id          = "prl_gcp"
  description = "Private Location on GCP"
  project     = "<ProjectId>"
  zone        = "<Zone>"
  machine = {
  #   type        = "c3-highcpu-4"
  #   preemptible = false
  #   engine      = "classic"
  #   image = {
  #     type    = "certified"
  #     java    = "latest"
  #     project = "<ProjectName>"
  #     family  = "<ImageFamily>"
  #     id      = "<ImageId>"
  #   }
  #   disk = {
  #     sizeGb = 20
  #   }
  #   network-interface = {
  #     project          = "<NetworkInterfaceProjectName>"
  #     network          = "<Network>"
  #     subnetwork       = "<SubNetwork>"
  #     with-external-ip = true
  #   }
  }
  # instance-template = "<InstanceTemplate>"
  # system-properties = {}
  # java-home         = "/usr/lib/jvm/zulu"
  # jvm-options       = ["-Xmx4G", "-Xms512M"]
  # enterprise-cloud = {
  #   Setup the proxy configuration for the private location
  #   Reference: https://docs.gatling.io/reference/install/cloud/private-locations/network/#configuring-a-proxy
  # }
}

# Create a control plane based on GCP VM
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/gcp/installation/
module "control-plane" {
  source            = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/control-plane"
  name              = "<Name>"
  description       = "My GCP control plane description"
  token-secret-name = "<TokenSecretName>"
  network = {
    zone    = "<Zone>"
    network = "<Network>"
    # subnetwork         = "<SubNetwork>"
    # enable-external-ip = true
  }
  locations = [module.location]
  # container = {
  #   image       = "gatlingcorp/control-plane:latest"
  #   command     = []
  #   environment = []
  # }
  # compute = {
  #   boot-disk-image            = "projects/cos-cloud/global/images/cos-stable-113-18244-85-49"
  #   machine-type               = "e2-standard-2"
  #   min-cpu-platform           = "<MinCpuPlatform>"
  #   confidential-instance-type = "ConfidentialInstanceType"
  #   shielded = {
  #     enable-secure-boot          = true
  #     enable-vtpm                 = true
  #     enable-integrity-monitoring = true
  #   }
  #   confidential = {
  #     enable        = false
  #     instance-type = "e2-standard-2"
  #   }
  # }
  # enterprise-cloud = {
  #   Setup the proxy configuration for the private location
  #   Reference: https://docs.gatling.io/reference/install/cloud/private-locations/network/#configuring-a-proxy
  # }
}
