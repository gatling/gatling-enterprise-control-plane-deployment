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

variable "token-secret-id" {
  description = "Secret identifier where the control token plane is stored."
  type        = string

  validation {
    condition     = length(var.token-secret-id) > 0
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

variable "container-app" {
  description = "Container app settings."
  type = object({
    init = optional(object({
      image = optional(string, "busybox")
    }), {})
    cpu     = optional(number, 1.0)
    memory  = optional(string, "2Gi")
    image   = optional(string, "gatlingcorp/control-plane:latest")
    command = optional(list(string), [])
    secrets = optional(list(object({
      name        = optional(string)
      secret-name = optional(string)
    })), [])
    environment = optional(list(object({
      name        = optional(string)
      value       = optional(string)
      secret-name = optional(string)
    })), [])
  })
  default = {}
}

variable "git" {
  description = "Conrol plane git configuration."
  type = object({
    host = optional(string, "github.com")
    credentials = optional(object({
      username        = optional(string, "")
      token-secret-id = optional(string, "")
    }), {})
    ssh = optional(object({
      storage-account-name = optional(string, "")
      file-share-name      = optional(string, "")
      file-name            = optional(string, "")
    }), {}),
    cache = optional(object({
      paths = optional(list(string), [])
    }), {})
  })
  default = {}

  validation {
    condition = (
      length(var.git.credentials.username) == 0 ||
      length(var.git.credentials.token-secret-id) > 0
    )
    error_message = "When credentials.username is set, credentials.token-secret-id must also be provided."
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
