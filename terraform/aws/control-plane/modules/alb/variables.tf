variable "name" {
  type        = string
  description = "Name of the control plane."
}

variable "vpc" {
  type        = string
  description = "The VPC ID for the ALB exposing the control plane for private packages upload."
}

variable "subnet_ids" {
  type        = list(string)
  description = "The subnet IDs for the control plane."
}

variable "security_group_ids" {
  type        = list(string)
  description = "ALB security group IDs to be used with the control plane container to generate a public URL for private packages."
}

variable "private_package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
}