variable "bucket" {
  type        = string
  description = "Bucket name of the S3 private package."

  validation {
    condition     = length(var.bucket) > 0
    error_message = "Bucket name of the S3 private package must not be empty."
  }
}

variable "path" {
  type        = string
  description = "Storage path on the S3 private package."
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
    port        = number
    bindAddress = string
    certificate = optional(object({
      path     = string
      password = optional(string)
    }))
  })
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
