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

variable "subnet_ids" {
  type        = list(string)
  description = "The subnet IDs for the control plane."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs to be used with the control plane."
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

variable "enterprise_cloud" {
  type    = map(any)
  default = {}
}

variable "command" {
  description = "Control plane image command"
  type        = list(string)
  default     = []
}

variable "secrets" {
  type    = list(map(string))
  default = []
}

variable "environment" {
  description = "Control plane image environment variables."
  type        = list(map(string))
  default     = []
}

variable "cloudWatch_logs" {
  description = "Control Plane Service CloudWatch logs."
  type        = bool
  default     = true
}

variable "ecr" {
  description = "Enable ECR IAM Permissions."
  type        = bool
  default     = false
}

variable "token_secret_arn" {
  type        = string
  description = "Control plane secret token ARN."
}
