variable "token" {
  type        = string
  description = "Token of the control plane"
  sensitive   = true
}

variable "name" {
  type        = string
  description = "Name of the control plane"
}

variable "description" {
  type        = string
  description = "Description of the control plane."
  default     = "My Azure control plane description"
}

variable "image" {
  type        = string
  description = "Image of the control plane."
  default     = "gatlingcorp/control-plane:latest"
}

variable "region" {
  type        = string
  description = "Region of the location."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name to be used with the control plane."
}

variable "conf_share_file_name" {
  type        = string
  description = "Name of the configuration object to be stored inside the storage share."
  default     = "control-plane.conf"
}

variable "locations" {
  description = "JSON configuration for the locations."
  type        = list(map(any))
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

variable "command" {
  description = "Control plane image command"
  type        = list(string)
  default     = []
}

variable "enterprise_cloud" {
  type    = map(any)
  default = {}
}
