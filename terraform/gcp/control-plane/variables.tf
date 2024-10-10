variable "name" {
  type        = string
  description = "Name of the control plane"
}

variable "token" {
  type        = string
  description = "Token of the control plane"
  sensitive   = true
}

variable "description" {
  type        = string
  description = "Description of the control plane."
  default     = "My GCP control plane description"
}

variable "machine_type" {
  description = "The zone for the control plane deployment."
  type        = string
  default     = "e2-standard-2"
}

variable "network_interface" {
  description = "VM custom network interface."
  type        = string
  default     = "default"
}

variable "secret_location" {
  type        = string
  description = "Secret Location."
}

variable "image" {
  type        = string
  description = "Image of the control plane."
  default     = "gatlingcorp/control-plane:latest"
}

variable "zone" {
  description = "The zone for the control plane deployment."
  type        = string
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

variable "secret_name" {
  type        = string
  description = "Secret name of the control plane configuration"
  default     = "control-plane-config"
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
