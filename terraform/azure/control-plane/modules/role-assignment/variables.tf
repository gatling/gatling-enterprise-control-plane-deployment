variable "container" {
  type        = any
  description = "Container running the control plane."
}

variable "private_package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
  default     = {}
}