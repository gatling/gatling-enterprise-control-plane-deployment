variable "name" {
  type        = string
  description = "Name of the control plane"
}

variable "token" {
  type        = string
  description = "Token of the control plane"
  sensitive   = true
}

variable "vpc" {
  type        = string
  description = "VPC to be used with the ALB exposing the control plane."
  default = ""
}

variable "subnet_ids" {
  type        = list(string)
  description = "The subnet IDs for the control plane."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs to be used with the control plane."
}

variable "alb_security_group_ids" {
  description = "ALB Security group"
  type        = list(any)
}

variable "conf_s3_name" {
  type        = string
  description = "S3 bucket name to be used with the control plane."
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