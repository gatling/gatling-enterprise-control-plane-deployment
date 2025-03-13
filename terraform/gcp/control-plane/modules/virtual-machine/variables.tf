variable "name" {
  description = "Name of the control plane"
  type        = string
}

variable "description" {
  description = "Description of the control plane."
  type        = string
}

variable "token_secret_name" {
  description = "Control plane secret token stored in GCP Secret Manager."
  type        = string
}

variable "service_email" {
  description = "Control plane service email."
  type        = string
}

variable "network" {
  description = "Network configuration for the VM"
  type = object({
    zone               = string
    network            = optional(string)
    subnetwork         = optional(string)
    enable_external_ip = bool
  })
}

variable "compute" {
  description = "Compute configuration for the VM"
  type = object({
    boot_disk_image            = string
    machine_type               = string
    min_cpu_platform           = optional(string)
    confidential_instance_type = optional(string)
    shielded = optional(object({
      enable_secure_boot          = bool
      enable_vtpm                 = bool
      enable_integrity_monitoring = bool
    }))
    confidential = optional(object({
      enable        = bool
      instance_type = string
    }))
  })
}

variable "container" {
  description = "Container configuration for the control plane"
  type = object({
    image   = string
    command = optional(list(string))
    env     = optional(list(string))
  })
}

variable "locations" {
  description = "JSON configuration for the private locations."
  type        = list(any)
}

variable "private_package" {
  description = "JSON configuration for the Private Package."
  type        = map(any)
}

variable "enterprise_cloud" {
  type = map(any)
}

variable "extra_content" {
  type = map(any)
}
