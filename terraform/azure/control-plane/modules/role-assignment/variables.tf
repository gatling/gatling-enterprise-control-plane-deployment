variable "container" {
  description = "Container running the control plane."
  type        = any
}

variable "private_package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
  default     = {}
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "vault_name" {
  description = "Vault name where the token plane secret is stored."
  type = string
}
