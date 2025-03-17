variable "storage_account_name" {
  type        = string
  description = "Storage account name to be used with the control plane."

  validation {
    condition     = length(var.storage_account_name) > 0
    error_message = "Storage account name must not be empty."
  }
}

variable "container_name" {
  type        = string
  description = "Container name of the control plane."

  validation {
    condition     = length(var.container_name) > 0
    error_message = "Container name must not be empty."
  }
}

variable "path" {
  type        = string
  description = "Storage path for private package."
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
