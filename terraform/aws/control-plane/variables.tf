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
  description = "Conrol plane git configuration."
  type = object({
    host = optional(string, "")
    credentials = optional(object({
      username            = optional(string, "")
      token-secret-arn = optional(string, "")
    }), {})
    ssh = optional(object({
      private-key-secret-arn = optional(string, "")
    }), {}),
    cache = optional(object({
      paths   = optional(list(string), [""])
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
  description = "Conrol plane task definition."
  type = object({
    iam-role-arn = optional(string, "")
    cpu          = optional(string, "1024")
    memory       = optional(string, "3072")
    image        = optional(string, "gatlingcorp/control-plane:latest")
    init = optional(object({
      image = optional(string, "busybox")
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
