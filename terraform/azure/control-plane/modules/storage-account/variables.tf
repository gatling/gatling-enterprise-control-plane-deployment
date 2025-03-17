variable "description" {
  description = "Description of the control plane."
  type        = string
}

variable "resource-group-name" {
  description = "Region of the control plane and its resources"
  type        = string
}

variable "storage-account-name" {
  description = "The name of the existing storage account"
  type        = string
}

variable "locations" {
  description = "JSON configuration for the locations."
  type        = list(any)
}

variable "private-package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
}

variable "enterprise-cloud" {
  type    = map(any)
}

variable "extra-content" {
  type    = map(any)
}
