variable "cp_name" {
  type        = string
  description = "Name of the control plane"
  default     = "gatling-cp"
}

variable "cp_token" {
  type        = string
  description = "Token of the control plane"
  sensitive   = true
}

variable "pp_flag" { // Set to true in order to activate Private Packages
  type        = bool
  description = "Flag to determine if the private packages and their related resources should be created."
  default     = false
}

variable "cp_security_group_ids" {
  type        = list(string)
  description = "Security group IDs to be used with the control plane."
  default     = ["sg-securitygroup"]
}

variable "cp_subnet_ids" {
  type        = list(string)
  description = "The subnet IDs for the control plane."
  default     = ["subnet-a", "subnet-b"]
}

variable "locations" {
  description = "List of location configurations"
  type = list(object({
    id                 = string
    description        = string
    region             = string
    java_version       = string
    security_group_ids = list(string)
    instance_type      = string
    subnet_ids         = list(string)
  }))

  default = [
    {
      id                 = "prl_aws",
      description        = "Private Location on AWS",
      region             = "eu-west-3",
      java_version       = "latest", // 11, 17, 21 or latest
      security_group_ids = ["sg-securitygroup"]
      instance_type      = "c6i.xlarge",
      subnet_ids         = ["subnet-a", "subnet-b"]
    }
  ]

  validation {
    condition = alltrue([
      for location in var.locations : can(regex("^(prl_)[0-9a-z_]{1,24}$", location.id))
    ])
    error_message = "Each location id must be prefixed by 'prl_', only consist of numbers 0-9, lowercase letters a-z, and underscores, and must be no longer than 30 characters in total."
  }

  validation {
    condition = alltrue([
      for location in var.locations : contains(["11", "17", "21", "latest"], location.java_version)
    ])
    error_message = "The java_version must be one of the following values: 11, 17, 21, or 'latest'."
  }
}

variable "pp_s3_dir" {
  type        = string
  description = "Name of the S3 private package directory."
  default     = ""
}

variable "pp_vpc" {
  type        = string
  description = "The VPC ID for the ALB exposing the control plane for private packages."
  default     = "vpc-id"
}

variable "pp_alb_security_group_ids" {
  type        = list(string)
  description = "ALB security group IDs to be used with the control plane container to generate a public URL for private packages."
  default     = ["subnet-a", "subnet-b"]
}