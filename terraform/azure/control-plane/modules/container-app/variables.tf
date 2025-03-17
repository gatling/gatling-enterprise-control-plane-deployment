variable "name" {
  description = "Name of the control plane."
  type        = string
}

variable "secret_id" {
  description = "Secret identifier where the control token plane is stored."
  type        = string
}

variable "region" {
  description = "Region of the location."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "container" {
  description = "Container settings."
  type = object({
    image   = string
    command = optional(list(string))
    env     = optional(list(map(string)))
    cpu     = number
    memory  = string
  })
}

variable "storage" {
  description = "Storage options."
  type = object({
    account_name               = string
    account_primary_access_key = string
    share_name                 = string
  })
}

variable "private_package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
  default     = {}
}
