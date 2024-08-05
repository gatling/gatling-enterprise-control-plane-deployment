variable "name" {
  type        = string
  description = "Control Plane role name."
}

variable "s3_bucket_name" {
  type        = string
  description = "S3 bucket name to be used with the control plane."
}

variable "private_package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
}

variable "cloudWatch_logs" {
  description = "Control Plane CloudWatch Logs."
  type        = bool
}