variable "token-secret-arn" {
  description = "Control plane secret token ARN."
  type        = string
}

variable "aws_region" {
  type        = string
}

variable "name" {
  description = "Control Plane role name."
  type        = string
}

variable "locations" {
  description = "JSON configuration for the locations."
  type        = list(any)
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
