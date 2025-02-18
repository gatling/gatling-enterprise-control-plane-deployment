variable "name" {
  type        = string
  description = "Name of the control plane."
}

variable "image" {
  type        = string
  description = "Image of the control plane."
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

variable "storage_account_primary_access_key" {
  type        = string
  description = "Storage account primary access key to be used with the control plane."
}

variable "storage_share_name" {
  type        = string
  description = "Storage share name to be used with the control plane."
}

variable "private_package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
  default     = {}
}

variable "command" {
  description = "Control plane image command"
  type        = list(string)
  default     = []
}

variable "enterprise_cloud" {
  type = map(any)
}

variable "secret_id" {
  description = "Secret identifier where the control token plane is stored."
  type = string
}

variable "container_cpu" {
  description = "Control Plane container CPU allocation."
  type        = number
}

variable "container_memory" {
  description = "Control Plane container memory allocation."
  type        = string
}
