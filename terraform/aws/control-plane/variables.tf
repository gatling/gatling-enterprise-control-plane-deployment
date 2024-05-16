variable "name" {
  type        = string
  description = "Name of the control plane"
}

variable "description" {
  type        = string
  description = "Description of the control plane."
  default = "My AWS control plane description"
}

variable "image" {
  type        = string
  description = "Image of the control plane"
  default = "gatlingcorp/control-plane:latest"
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
  default = []
}

variable "conf_s3_name" {
  type        = string
  description = "S3 bucket name to be used with the control plane."
}

variable "conf_s3_object_name" {
  type        = string
  description = "Configuration object name to be stored in the S3 bucket."
}

variable "port" {
  type        = number
  description = "Server Port"
  default = 8080
}

variable "bind_address" {
  type        = string
  description = "Server bind address"
  default = "0.0.0.0"
}

variable "certificate_path" {
  type        = string
  description = "Server certificte path"
  default = ""
}

variable "certificate_password" {
  type        = string
  description = "Server certificte password"
  default = ""
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