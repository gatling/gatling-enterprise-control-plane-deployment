variable "bucket" {
  type        = string
  description = "Storage bucket of the private package."

  validation {
    condition     = length(var.bucket) > 0
    error_message = "Bucket must not be empty."
  }
}

variable "path" {
  type        = string
  description = "Storage bucket path for private package."
  default     = ""
}

variable "project" {
  type        = string
  description = "Project id of the private package storage bucket."

  validation {
    condition     = length(var.project) > 0
    error_message = "Project must not be empty."
  }
}

variable "upload" {
  type = object({
    directory = string
  })
  description = "Control Plane Repository Server Temporary Upload Directory."
  default = {
    directory = "/tmp"
  }
}

variable "server" {
  type = object({
    port        = number
    bindAddress = string
    certificate = optional(object({
      path     = string
      password = optional(string)
    }))
  })
  description = "Control Plane Repository Server configuration."
  default = {
    port        = 8080,
    bindAddress = "0.0.0.0",
    certificate = null
  }

  validation {
    condition     = var.server.port > 0 && var.server.port <= 65535
    error_message = "Server port must be between 1 and 65535."
  }

  validation {
    condition     = length(var.server.bindAddress) > 0
    error_message = "Server bindAddress must not be empty."
  }
}
