variable "container" {
  description = "Container running the control plane."
  type        = any
}

variable "resource-group-name" {
  description = "Resource group name."
  type        = string
}

variable "vault-name" {
  description = "Vault name where the control plane token secret is stored."
  type = string
}

variable "private-package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
  default     = {}
}
