variable "bucket" {
  description = "Storage bucket of the private package."
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "Bucket must not be empty."
  }
}

variable "project" {
  description = "Project id of the private package storage bucket."
  type        = string

  validation {
    condition     = length(var.project) > 0
    error_message = "Project must not be empty."
  }
}

variable "path" {
  description = "Storage bucket path for private package."
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
