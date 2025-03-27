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

variable "server" {
  description = "Control Plane Repository Server configuration."
  type = object({
    port        = optional(number, 8080)
    bindAddress = optional(string, "0.0.0.0")
    certificate = optional(object({
      path     = string
      password = optional(string)
    }), {})
  })
  default = {}

  validation {
    condition     = var.server.port > 0 && var.server.port <= 65535
    error_message = "Server port must be between 1 and 65535."
  }
  validation {
    condition     = length(var.server.bindAddress) > 0
    error_message = "Server bindAddress must not be empty."
  }
}
