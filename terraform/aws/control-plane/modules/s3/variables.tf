variable "name" {
  type        = string
  description = "Name of the S3 bucket."
}

variable "object_name" {
  type        = string
  description = "Name of the configuration object to be stored inside the S3 Bucket."
}

variable "token" {
  type        = string
  description = "Token of the control plane"
  sensitive   = true
}

variable "locations" {
  description = "JSON configuration for the locations."
  type        = list(any)
}

variable "private_package" {
  description = "JSON configuration for the Private Package."
  type        = map(any)
}