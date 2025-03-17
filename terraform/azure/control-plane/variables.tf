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

variable "vault_name" {
  description = "Vault name where the control plane token secret is stored."
  type        = string

  validation {
    condition     = length(var.vault_name) > 0
    error_message = "Vault name must not be empty."
  }
}

variable "secret_id" {
  description = "Secret identifier where the control token plane is stored."
  type        = string

  validation {
    condition     = length(var.secret_id) > 0
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

variable "resource_group_name" {
  description = "Resource group name."
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group must not be empty."
  }
}

variable "container" {
  description = "Container settings."
  type = object({
    image   = string
    command = optional(list(string))
    env = optional(list(object({
      name        = string
      value       = optional(string)
      secret_name = optional(string)
    })))
    cpu    = number
    memory = string
  })
  default = {
    image  = "gatlingcorp/control-plane:latest"
    cpu    = 1.0
    memory = "2Gi"
    command = []
    env     = []
  }
}

variable "storage_account_name" {
  description = "Storage account name to be used with the control plane."
  type        = string

  validation {
    condition     = length(var.storage_account_name) > 0
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

variable "private_package" {
  description = "JSON configuration for the private packages."
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
