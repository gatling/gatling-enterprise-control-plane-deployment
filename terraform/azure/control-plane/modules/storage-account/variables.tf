variable "token" {
  type        = string
  description = "Token of the control plane"
  sensitive   = true
}

variable "description" {
  type        = string
  description = "Description of the control plane."
}

variable "resource_group_name" {
  type        = string
  description = "Region of the control plane and its resources"
}

variable "storage_account_name" {
  description = "The name of the existing storage account"
  type        = string
}

variable "conf_share_file_name" {
  type        = string
  description = "Name of the configuration object to be stored inside the storage share."
}

variable "locations" {
  description = "JSON configuration for the locations."
  type        = list(any)
}

variable "private_package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
  default     = {}
}

variable "extra_content" {
  type    = map(any)
  default = {}
}
