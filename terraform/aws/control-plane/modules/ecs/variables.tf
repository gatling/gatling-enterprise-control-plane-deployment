variable "ecs_tasks_iam_role_arn" {
  type        = string
  description = "Control Plane IAM Role ARN."
}

variable "name" {
  type        = string
  description = "Name of the control plane."
}

variable "description" {
  type        = string
  description = "Description of the control plane."
}

variable "subnet_ids" {
  type        = list(string)
  description = "The subnet IDs for the control plane."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs to be used with the control plane."
}

variable "image" {
  type        = string
  description = "Image of the control plane."
}

variable "command" {
  description = "Control plane image command"
  type        = list(string)
  default     = []
}

variable "secrets" {
  type = list(map(string))
}

variable "environment" {
  description = "Control plane environment variables."
  type        = list(map(string))
}

variable "locations" {
  description = "JSON configuration for the locations."
  type        = list(any)
}

variable "private_package" {
  description = "JSON configuration for the Private Package."
  type        = map(any)
}

variable "enterprise_cloud" {
  type = map(any)
}

variable "extra_content" {
  type = map(any)
}

variable "cloudWatch_logs" {
  description = "Control Plane CloudWatch Logs."
  type        = bool
}

variable "token_secret_arn" {
  type        = string
  description = "Secret Token ARN of the control plane"
}
