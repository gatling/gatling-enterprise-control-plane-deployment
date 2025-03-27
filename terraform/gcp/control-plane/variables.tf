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

variable "token-secret-name" {
  description = "Control plane secret token stored in GCP Secret Manager."
  type        = string

  validation {
    condition     = length(var.token-secret-name) > 0
    error_message = "The token secret name must not be empty."
  }
}

variable "network" {
  description = "Network configuration for the VM"
  type = object({
    zone               = string
    network            = optional(string)
    subnetwork         = optional(string)
    enable-external-ip = optional(bool, true)
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
}

variable "compute" {
  description = "Compute configuration for the VM"
  type = object({
    boot-disk-image            = optional(string, "projects/cos-cloud/global/images/cos-stable-113-18244-85-49")
    machine-type               = optional(string, "e2-standard-2")
    min-cpu-platform           = optional(string)
    confidential-instance-type = optional(string)
    shielded = optional(object({
      enable-secure-boot          = optional(bool, true)
      enable-vtpm                 = optional(bool, true)
      enable-integrity-monitoring = optional(bool, true)
    }), {})
    confidential = optional(object({
      enable        = optional(bool, false)
      instance-type = optional(string, "e2-standard-2")
    }), {})
  })
  default = {}
}

variable "container" {
  description = "Container configuration for the control plane"
  type = object({
    image       = optional(string, "gatlingcorp/control-plane:latest")
    command     = optional(list(string), [])
    environment = optional(list(string), [])
  })
  default = {}
}

variable "locations" {
  description = "JSON configuration for the private locations."
  type        = list(any)

  validation {
    condition     = length(var.locations) > 0
    error_message = "At least one private location must be specified."
  }
}

variable "private-package" {
  description = "JSON configuration for the Private Package."
  type        = map(any)
  default     = {}
}

variable "enterprise-cloud" {
  type    = map(any)
  default = {}
}

variable "extra-content" {
  type    = map(any)
  default = {}
}
