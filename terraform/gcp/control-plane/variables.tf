variable "name" {
  description = "Name of the control plane"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "The name of the control plane must not be empty."
  }
}

variable "description" {
  description = "Description of the control plane."
  type        = string
  default     = "My GCP control plane description"
}

variable "token_secret_name" {
  description = "Control plane secret token stored in GCP Secret Manager."
  type        = string

  validation {
    condition     = length(var.token_secret_name) > 0
    error_message = "The token secret name must not be empty."
  }
}

variable "network" {
  description = "Network configuration for the VM"
  type = object({
    zone               = string
    network            = optional(string)
    subnetwork         = optional(string)
    enable_external_ip = bool
  })

  validation {
    condition     = var.network.zone != null
    error_message = "Zone must be provided."
  }
  validation {
    condition = (
      (var.network.network != null ? length(var.network.network) : 0) > 0 ||
      (var.network.subnetwork != null ? length(var.network.subnetwork) : 0) > 0
    )
    error_message = "Either network or subnetwork must be specified in the network configuration."
  }
  validation {
    condition     = var.network.enable_external_ip != null
    error_message = "Zone must not be empty."
  }
}

variable "compute" {
  description = "Compute configuration for the VM"
  type = object({
    boot_disk_image            = string
    machine_type               = string
    min_cpu_platform           = optional(string)
    confidential_instance_type = optional(string)
    shielded = object({
      enable_secure_boot          = bool
      enable_vtpm                 = bool
      enable_integrity_monitoring = bool
    })
    confidential = object({
      enable        = bool
      instance_type = string
    })
  })
  default = {
    machine_type    = "e2-standard-2"
    boot_disk_image = "projects/cos-cloud/global/images/cos-stable-113-18244-85-49"
    shielded = {
      enable_secure_boot          = true
      enable_vtpm                 = true
      enable_integrity_monitoring = true
    }
    confidential = {
      enable        = false
      instance_type = "e2-standard-2"
    }
  }
}

variable "container" {
  description = "Container configuration for the control plane"
  type = object({
    image   = string
    command = optional(list(string))
    env     = optional(list(string))
  })
  default = {
    image   = "gatlingcorp/control-plane:latest"
    command = []
    env     = []
  }
}

variable "locations" {
  description = "JSON configuration for the private locations."
  type        = list(any)

  validation {
    condition     = length(var.locations) > 0
    error_message = "At least one private location must be specified."
  }
}

variable "private_package" {
  description = "JSON configuration for the Private Package."
  type        = map(any)
  default     = {}
}

variable "enterprise_cloud" {
  type    = map(any)
  default = {}
}

variable "extra_content" {
  type    = map(any)
  default = {}
}
