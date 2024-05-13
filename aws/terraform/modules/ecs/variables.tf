variable "cp_name" {
  type        = string
  description = "Name of the control plane."
}

variable "cp_iam_role_arn" {
  type        = string
  description = "Control Plane IAM Role ARN."
}

variable "pp_flag" {
  type        = bool
  description = "Flag to determine if the private packages and their related resources should be created."
}

variable "cp_subnet_ids" {
  type        = list(string)
  description = "The subnet IDs for the control plane."
}

variable "cp_security_group_ids" {
  type        = list(string)
  description = "Security group IDs to be used with the control plane."
}

variable "pp_alb_target_group_arn" {
  type        = string
  description = "Target Group ARN of the Application Load Balancer."
}

variable "pp_alb_listener_id" {
  type        = string
  description = "Listener ID of the Application Load Balancer."
}