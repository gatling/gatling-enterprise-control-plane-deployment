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
