variable "bucket" {
  type        = string
  description = "Bucket name of the S3 private package."
}

variable "path" {
  type        = string
  description = "Storage path on the S3 private package."
  default     = ""
}

variable "uploadDir" {
  type        = string
  description = "Control Plane Repository Server Temporary Upload Directory."
  default     = "/tmp"
}

variable "port" {
  type        = number
  description = "Control Plane Repository Server Port."
  default     = 8080
}

variable "bindAddress" {
  type        = string
  description = "Control Plane Repository Server Bind Address."
  default     = "0.0.0.0"
}

variable "certPath" {
  type        = string
  description = "Control Plane Repository Server Certificate Path."
  default     = ""
}

variable "certPassword" {
  type        = string
  description = "Control Plane Repository Server Certificate Password."
  default     = ""
}
