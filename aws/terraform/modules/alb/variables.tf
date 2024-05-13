variable "cp_name" {
  type        = string
  description = "Name of the control plane."
}

variable "pp_flag" {
  type        = bool
  description = "Flag to determine if the private packages and their related resources should be created."
}

variable "pp_vpc" {
  type        = string
  description = "The VPC ID for the ALB exposing the control plane for private packages upload."
}

variable "cp_subnet_ids" {
  type        = list(string)
  description = "The subnet IDs for the control plane."
}

variable "pp_alb_security_group_ids" {
  type        = list(string)
  description = "ALB security group IDs to be used with the control plane container to generate a public URL for private packages."
}

variable "pp_s3_dir" {
  type        = string
  description = "Name of the S3 private package directory."
}