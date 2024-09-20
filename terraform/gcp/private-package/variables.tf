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