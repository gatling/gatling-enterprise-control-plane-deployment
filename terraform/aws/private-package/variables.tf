variable "bucket" {
  type        = string
  description = "Bucket name of the S3 private package"
}

variable "path" {
  type        = string
  description = "Storage path on the S3 private package"
  default = ""
}