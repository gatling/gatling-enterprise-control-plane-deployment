variable "name" {
  type        = string
  description = "Control Plane role name."
}

variable "private-package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
}

variable "cloudwatch-logs" {
  description = "Control Plane CloudWatch Logs."
  type        = bool
}

variable "ecr" {
  description = "Enable ECR IAM Permissions."
  type        = bool
}

variable "token-secret-arn" {
  type        = string
  description = "Control plane secret token ARN."
}
