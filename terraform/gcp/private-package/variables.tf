variable "bucket" {
  type        = string
  description = "Storage bucket of the private package."
}

variable "path" {
  type        = string
  description = "Storage bucket path for private package."
  default     = ""
}

variable "project" {
  type        = string
  description = "Project id of the private package storage bucket."
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
