variable "cp_name" {
  type        = string
  description = "Name of the control plane."
}

variable "s3_policy_name" {
  type        = string
  description = "Name of the S3 policy"
  default     = "GatlingControlPlaneConfSidecarPolicy"
}

variable "ec2_policy_name" {
  type        = string
  description = "Name of the EC2 policy"
  default     = "GatlingControlPlaneEC2Policy"
}

variable "pp_s3_policy_name" {
  type        = string
  description = "Name of the S3 Packages policy"
  default     = "GatlingControlPlaneS3PackagesPolicy"
}

variable "pp_flag" {
  type        = bool
  description = "Flag to determine if the private packages and their related resources should be created."
}