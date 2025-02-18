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

variable "vault_name" {
  description = "Vault name where the control plane token secret is stored."
  type        = string
}

variable "secret_id" {
  description = "Secret identifier where the control token plane is stored."
  type = string
}

variable "container_cpu" {
  description = "Control Plane container CPU allocation."
  type    = number
  default = 1.0
}

variable "container_memory" {
  description = "Control Plane container memory allocation."
  type    = string
  default = "2Gi"
}
