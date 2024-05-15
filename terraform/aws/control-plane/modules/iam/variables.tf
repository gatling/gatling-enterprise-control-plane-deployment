variable "name" {
  type        = string
  description = "Name of the Control Plane role."
}

variable "s3_bucket_name" {
  type        = string
  description = "S3 bucket name to be used with the control plane."
}

variable "private_package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
}