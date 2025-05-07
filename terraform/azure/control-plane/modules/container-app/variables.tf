variable "name" {
  description = "Name of the control plane."
  type        = string
}

variable "description" {
  description = "Description of the control plane."
  type        = string
}

variable "token-secret-id" {
  description = "Secret identifier where the control token plane is stored."
  type        = string
}

variable "region" {
  description = "Region of the location."
  type        = string
}

variable "resource-group-name" {
  description = "Resource group name."
  type        = string
}

variable "container-app" {
  description = "Container app settings."
  type = object({
    init = object({
      image = string
    })
    cpu         = number
    memory      = string
    image       = string
    command     = list(string)
    secrets     = list(map(string))
    environment = list(map(string))
  })
}

variable "git" {
  description = "Conrol plane git configuration."
  type = object({
    host = string
    credentials = object({
      username        = string
      token-secret-id = string
    })
    ssh = object({
      storage-account-name       = string
      file-share-name            = string
      file-name                  = string
      account-primary-access-key = optional(string)
    }),
    cache = object({
      paths = list(string)
    })
  })
}

variable "locations" {
  description = "JSON configuration for the locations."
  type        = list(any)
}

variable "private-package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
  default     = {}
}

variable "enterprise-cloud" {
  type = map(any)
}

variable "extra-content" {
  type = map(any)
}
