variable "name" {
  type        = string
  description = "Configuration file name in Secret Manager."
  default     = "control-plane-config"
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