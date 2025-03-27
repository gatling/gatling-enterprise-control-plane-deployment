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
  default     = "My Azure control plane description"
}

variable "vault-name" {
  description = "Vault name where the control plane token secret is stored."
  type        = string

  validation {
    condition     = length(var.vault-name) > 0
    error_message = "Vault name must not be empty."
  }
}

variable "secret-id" {
  description = "Secret identifier where the control token plane is stored."
  type        = string

  validation {
    condition     = length(var.secret-id) > 0
    error_message = "Secret identifier must not be empty."
  }
}

variable "region" {
  description = "Region of the location."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "Region must not be empty."
  }
}

variable "resource-group-name" {
  description = "Resource group name."
  type        = string

  validation {
    condition     = length(var.resource-group-name) > 0
    error_message = "Resource group must not be empty."
  }
}

variable "container" {
  description = "Container settings."
  type = object({
    image   = optional(string, "gatlingcorp/control-plane:latest")
    command = optional(list(string), [])
    environment = optional(list(object({
      name        = optional(string)
      value       = optional(string)
      secret-name = optional(string)
    })), [])
    cpu    = optional(number, 1.0)
    memory = optional(string, "2Gi")
  })
  default = {}
}

variable "storage-account-name" {
  description = "Storage account name to be used with the control plane."
  type        = string

  validation {
    condition     = length(var.storage-account-name) > 0
    error_message = "Storage account name must not be empty."
  }
}

variable "locations" {
  description = "JSON configuration for the locations."
  type        = list(any)

  validation {
    condition     = length(var.locations) > 0
    error_message = "At least one private location must be specified."
  }
}

variable "private-package" {
  description = "JSON configuration for the private packages."
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
