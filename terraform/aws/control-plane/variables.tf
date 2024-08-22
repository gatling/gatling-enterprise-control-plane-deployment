variable "name" {
  type        = string
  description = "Name of the control plane"
}

variable "description" {
  type        = string
  description = "Description of the control plane."
  default     = "My AWS control plane description"
}

variable "image" {
  type        = string
  description = "Image of the control plane."
  default     = "gatlingcorp/control-plane:latest"
}

variable "token" {
  type        = string
  description = "Token of the control plane"
  sensitive   = true
}

variable "subnet_ids" {
  type        = list(string)
  description = "The subnet IDs for the control plane."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs to be used with the control plane."
}

variable "conf_s3_name" {
  type        = string
  description = "S3 bucket name to be used with the control plane."
}

variable "conf_s3_object_name" {
  type        = string
  description = "Configuration object name to be stored in the S3 bucket."
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

variable "cloudWatch_logs" {
  description = "Control Plane Service CloudWatch logs."
  type        = bool
  default     = true
}