variable "storage_account_name" {
  type        = string
  description = "Storage account name to be used with the control plane."
}

variable "container_name" {
  type        = string
  description = "Container name of the control plane."
}

variable "path" {
  type        = string
  description = "Storage path on the S3 private package."
  default     = ""
}