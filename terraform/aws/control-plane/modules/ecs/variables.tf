variable "name" {
  type        = string
  description = "Name of the control plane."
}

variable "image" {
  type        = string
  description = "Image of the control plane."
}

variable "subnet_ids" {
  type        = list(string)
  description = "The subnet IDs for the control plane."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs to be used with the control plane."
}

variable "ecs_tasks_iam_role_arn" {
  type        = string
  description = "Control Plane IAM Role ARN."
}

variable "conf_s3_name" {
  type        = string
  description = "S3 bucket name to be used with the control plane."
}

variable "private_package" {
  description = "JSON configuration for the Private Package."
  type        = map(any)
}

variable "command" {
  description = "Control plane image command"
  type = list(string)
  default = []
}
