variable "storage-account-name" {
  description = "Storage account name to be used with the control plane."
  type        = string

  validation {
    condition     = length(var.storage-account-name) > 0
    error_message = "Storage account name must not be empty."
  }
}

variable "control-plane-name" {
  description = "Control plane name."
  type        = string

  validation {
    condition     = length(var.control-plane-name) > 0
    error_message = "Control plane name must not be empty."
  }
}

variable "path" {
  description = "Storage path for private package."
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
      path     = optional(string)
      password = optional(string, null)
    }), null)
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
