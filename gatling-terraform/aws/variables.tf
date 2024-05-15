variable "token" {
  type        = string
  description = "Tooken of the Control Plane."
}

variable "region" {
  type        = string
  description = "Region used to deploy the Location."
}

variable "vpc" {
  type        = string
  description = "VPC of the Control Plane ALB."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets of the Control Plane."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security Group IDs of the Control Plane."
}

variable "location_description" {
  type        = string
  description = "Description of the Location."
}

variable "location_instance_type" {
  type        = string
  description = "Instance type for the Location."
}

variable "location_java_version" {
  type        = string
  description = "Java version for the Location."

  validation {
    condition     = contains(["11", "17", "21", "latest"], var.location_java_version)
    error_message = "The java_version must be one of the following values: 11, 17, 21, or 'latest'."
  }
}

variable "alb_security_group_ids" {
  type        = list(string)
  description = "Security Group IDs of the Control Plane's ALB."
  default = []
}

variable "conf_s3_name" {
  type        = string
  description = "Name of the S3 bucket storing the configuration of the Control Plane."
}

variable "package_name" {
  type        = string
  description = "Name of the S3 bucket storing the Private Packages."
}

variable "package_path" {
  type        = string
  description = "Path for storing the Private Packages in the S3 bucket."
}