variable "bucket" {
  description = "Bucket name of the S3 private package."
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "Bucket name of the S3 private package must not be empty."
  }
}

variable "path" {
  description = "Storage path on the S3 private package."
  type        = string
  default     = ""
}

variable "upload" {
  description = "Control Plane Repository Server Temporary Upload Directory."
  type = object({
    directory = string
  })
  default = {
    directory = "/tmp"
  }
}
