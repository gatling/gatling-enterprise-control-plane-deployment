# GCP-private-package

[<picture><source media="(prefers-color-scheme: dark)" srcset="https://docs.gatling.io/images/logo-gatling.svg"><img src="https://docs.gatling.io/images/logo-gatling-noir.svg" alt="Gatling" width="50%"></picture>](https://gatling.io)

This Terraform configuration sets up the GCP infrastructure for Gatling Enterprise's Private Locations & Private Packages deployment. The configuration uses three modules: one for specifying the location, another for specifying the private package, and a third for deploying the control plane.

<img width="2456" alt="gcp-diagram" src="https://github.com/user-attachments/assets/99ec5459-e5d2-47fd-9629-449b094b156f" />

> [!WARNING]
> These scripts are here to help you bootstrapping your installation.
> They are likely to frequently change in an incompatible fashion.
> Feel free to fork them and adapt them to your needs

## Prerequisites

- Gatling Enterprise [account](https://auth.gatling.io/auth/realms/gatling/protocol/openid-connect/auth?client_id=gatling-enterprise-cloud-public&response_type=code&scope=openid&redirect_uri=https%3A%2F%2Fcloud.gatling.io%2Fr%2Fgatling) with Private Locations enabled. To access this feature, please contact our [technical support](https://gatlingcorp.atlassian.net/servicedesk/customer/portal/8/group/12/create/59?summary=Private+Locations&description=Contact%20email%3A%20%3Cemail%3E%0A%0AHello%2C%20we%20would%20like%20to%20enable%20the%20private%20locations%20feature%20on%20our%20organization.).
- A control plane [token](https://docs.gatling.io/reference/install/cloud/private-locations/introduction/#token) stored in GCP Secret Manager.
- Terraform installed on your local machine.
- GCP credentials configured.

## Configuration

### Provider

The provider block specifies the Azure subscription to use:

```sh
provider "google" {
  project = "<ProjectId>"
  region  = "<Region>"
}
```

## Modules

### Private Package

This module specifies the private package parameters for the control plane. It includes the container name and storage account name.

```sh
# Configure a private package (control plane repository & server)
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/private-packages/#gcp-cloud-storage
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/private-packages/#control-plane-server
module "private-package" {
  source  = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/private-package"
  project = "<ProjectId>"
  bucket  = "<BucketName>"
  # path    = ""
  # upload = {
  #   directory = "/tmp"
  # }
  # server = {
  #   port        = 8080
  #   bindAddress = "0.0.0.0"
  #   certificate = {
  #     path     = "/path/to/certificate.p12"
  #     password = "password"
  #   }
  # }
}
```

### Location

This module specifies the location parameters for the control plane, including project id and zone.

```sh
# Configure a GCP private location
# Reference: https://docs.gatling.io/reference/install/cloud/private-locations/gcp/configuration/#control-plane-configuration-file
module "location" {
  source      = "git::https://github.com/gatling/gatling-enterprise-control-plane-deployment//terraform/gcp/location"
  id          = "prl_gcp"
  description = "Private Location on GCP"
  project     = "<ProjectId>"
  zone        = "<Zone>"
  # instance-template = "<InstanceTemplate>"
  # machine = {
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
  # }
  # system-properties = {}
  # java-home         = "/usr/lib/jvm/zulu"
  # jvm-options       = ["-Xmx4G", "-Xms512M"]
  # enterprise-cloud = {
  #   Setup the proxy configuration for the private location
  #   Reference: https://docs.gatling.io/reference/install/cloud/private-locations/network/#configuring-a-proxy
  # }
}
```

### Control Plane

Sets up the control plane with configurations for networking, security, and storage.

```sh
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
  locations       = [module.location]
  private-package = module.private-package
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
```

## Usage

1. Initialize Terraform

```console
terraform init
```

2. Validate the configuration

```console
terraform plan
```

3. Apply the configuration

```console
terraform apply
```
