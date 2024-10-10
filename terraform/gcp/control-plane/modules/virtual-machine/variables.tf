variable "name" {
  type        = string
  description = "Name of the control plane"
}

variable "zone" {
  description = "The zone for the control plane deployment."
  type        = string
}

variable "machine_type" {
  description = "The zone for the control plane deployment."
  type        = string
}

variable "network_interface" {
  description = "VM custom network interface."
  type        = string
}

variable "image" {
  type        = string
  description = "Image of the control plane."
}

variable "secret_name" {
  type        = string
  description = "Control plane secret name."
}

variable "service_email" {
  type        = string
  description = "Control plane service email."
}

variable "private_package" {
  description = "JSON configuration for the Private Package."
  type        = map(any)
}

variable "command" {
  description = "Control plane image command"
  type        = list(string)
  default     = []
}
