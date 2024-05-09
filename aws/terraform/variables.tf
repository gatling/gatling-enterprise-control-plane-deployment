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

variable "cp_security_group_ids" {
  type        = list(string)
  description = "Security group IDs to be used with the control plane"
  default     = ["sg-securitygroup"]
}

variable "cp_subnet_ids" {
  type        = list(string)
  description = "The subnet IDs for the control plane"
  default     = ["subnet-a", "subnet-b"]
}

variable "locations" {
  description = "List of location configurations"
  type = list(object({
    id              = string
    description     = string
    region          = string
    java_version    = string
    security_group_ids = list(string)
    instance_type   = string
    subnet_ids      = list(string)
  }))

  default = [
    {
      id              = "prl_private_location_example",
      description     = "Private Location on AWS",
      region          = "eu-west-3",
      java_version    = "latest",
      security_group_ids = ["sg-mysecuritygroup"]
      instance_type   = "c6i.xlarge",
      subnet_ids      = ["subnet-a", "subnet-b"]
    },
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