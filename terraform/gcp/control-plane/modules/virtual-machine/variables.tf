variable "name" {
  description = "Name of the control plane"
  type        = string
}

variable "description" {
  description = "Description of the control plane."
  type        = string
}

variable "token-secret-name" {
  description = "Control plane secret token stored in GCP Secret Manager."
  type        = string
}

variable "service-email" {
  description = "Control plane service email."
  type        = string
}

variable "network" {
  description = "Network configuration for the VM"
  type = object({
    zone               = string
    network            = optional(string)
    subnetwork         = optional(string)
    enable-external-ip = bool
  })
}

variable "compute" {
  description = "Compute configuration for the VM"
  type = object({
    boot-disk-image            = string
    machine-type               = string
    min-cpu-platform           = optional(string)
    confidential-instance-type = optional(string)
    shielded = optional(object({
      enable-secure-boot          = bool
      enable-vtpm                 = bool
      enable-integrity-monitoring = bool
    }))
    confidential = optional(object({
      enable        = bool
      instance-type = string
    }))
  })
}

variable "container" {
  description = "Container configuration for the control plane"
  type = object({
    image       = string
    command     = optional(list(string))
    environment = optional(list(string))
  })
}

variable "locations" {
  description = "JSON configuration for the private locations."
  type        = list(any)
}

variable "private-package" {
  description = "JSON configuration for the Private Package."
  type        = map(any)
}

variable "enterprise-cloud" {
  type = map(any)
}

variable "extra-content" {
  type = map(any)
}
