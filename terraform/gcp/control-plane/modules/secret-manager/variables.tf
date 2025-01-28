variable "name" {
  type        = string
  description = "Configuration file name in Secret Manager."
}

variable "description" {
  type        = string
  description = "Description of the control plane."
}

variable "token" {
  type        = string
  description = "Token of the control plane"
  sensitive   = true
}

variable "secret_location" {
  type        = string
  description = "Secret Location."
}

variable "locations" {
  description = "JSON configuration for the locations."
  type        = list(any)
}

variable "private_package" {
  description = "JSON configuration for the Private Package."
  type        = map(any)
}

variable "extra_content" {
  type    = map(any)
  default = {}
}

variable "enterprise_cloud" {
  type    = map(any)
  default = {}
}
