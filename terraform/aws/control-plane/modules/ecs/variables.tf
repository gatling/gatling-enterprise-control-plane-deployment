variable "name" {
  type        = string
  description = "Name of the control plane."
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

variable "alb_security_group_ids" {
  description = "ALB Security group"
  type        = list(any)
}

variable "alb_target_group_arn" {
  description = "Private Package ALB Target Group ARN."
  type        = string
}