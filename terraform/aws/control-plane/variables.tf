variable "name" {
  description = "Name of the control plane"
  type        = string
}

variable "description" {
  description = "Description of the control plane."
  type        = string
  default     = "My AWS control plane description"
}

variable "token-secret-arn" {
  description = "Control plane secret token ARN."
  type        = string
}

variable "subnets" {
  description = "The subnet IDs for the control plane."
  type        = list(string)

  validation {
    condition     = length(var.subnets) > 0
    error_message = "Subnets must not be empty."
  }
}

variable "security-groups" {
  description = "Security group IDs to be used with the control plane."
  type        = list(string)

  validation {
    condition     = length(var.security-groups) > 0
    error_message = "Security groups must not be empty."
  }
}

variable "assign-public-ip" {
  description = "Assign public IP to the control plane service."
  type        = bool
  default     = true
}

variable "git" {
  description = "Control plane git configuration."
  type = object({
    host = optional(string, "github.com")
    credentials = optional(object({
      username         = optional(string, "")
      token-secret-arn = optional(string, "")
    }), {})
    ssh = optional(object({
      private-key-secret-arn = optional(string, "")
    }), {}),
    cache = optional(object({
      paths = optional(list(string), [])
    }), {})
  })
  default = {}

  validation {
    condition = (
      length(var.git.credentials.username) == 0 ||
      length(var.git.credentials.token-secret-arn) > 0
    )
    error_message = "When credentials.username is set, credentials.token-secret-arn must also be provided."
  }
}

variable "task" {
  description = "Control plane task definition."
  type = object({
    iam-role-arn = optional(string, "")
    cpu          = optional(string, "1024")
    memory       = optional(string, "3072")
    image        = optional(string, "gatlingcorp/control-plane:latest")
    init = optional(object({
      image       = optional(string, "busybox")
      command     = optional(list(string), [])
      environment = optional(list(map(string)), [])
      secrets     = optional(list(map(string)), [])
    }), {})
    command         = optional(list(string), [])
    secrets         = optional(list(map(string)), [])
    environment     = optional(list(map(string)), [])
    cloudwatch-logs = optional(bool, true)
    ecr             = optional(bool, false)
  })
  default = {}
}

variable "locations" {
  description = "JSON configuration for the locations."
  type        = list(map(any))
}

variable "private-package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
  default     = {}
}

variable "enterprise-cloud" {
  description = "Enterprise Cloud network settings: http proxy, fwd proxy, etc."
  type        = map(any)
  default     = {}
}

variable "extra-content" {
  type    = map(any)
  default = {}
}

variable "certificates" {
  description = <<-EOT
    Content of custom CA certificates in PEM format to be added to the Java truststore.
    Use file() function to load from a file: certificates = file("path/to/cert.pem")
    Multiple certificates can be included in a single PEM file.
    Leave empty or omit to skip certificate installation.
  EOT
  type        = string
  default     = ""
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
