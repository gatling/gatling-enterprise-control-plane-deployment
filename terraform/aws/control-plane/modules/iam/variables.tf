variable "name" {
  type        = string
  description = "Control Plane role name."
}

variable "private_package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
}

variable "cloudWatch_logs" {
  description = "Control Plane CloudWatch Logs."
  type        = bool
}

variable "ecr" {
  description = "Enable ECR IAM Permissions."
  type        = bool
}

variable "token_secret_arn" {
  type        = string
  description = "Control plane secret token ARN."
}
