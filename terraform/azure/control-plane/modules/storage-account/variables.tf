variable "description" {
  description = "Description of the control plane."
  type        = string
}

variable "resource_group_name" {
  description = "Region of the control plane and its resources"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the existing storage account"
  type        = string
}

variable "locations" {
  description = "JSON configuration for the locations."
  type        = list(any)
}

variable "private_package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
}

variable "enterprise_cloud" {
  type    = map(any)
}

variable "extra_content" {
  type    = map(any)
}
