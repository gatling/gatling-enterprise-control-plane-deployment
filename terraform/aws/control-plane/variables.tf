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
}

variable "security-groups" {
  description = "Security group IDs to be used with the control plane."
  type        = list(string)
}

variable "assign-public-ip" {
  description = "Assign public IP o th control plane service."
  type        = bool
  default     = true
}

variable "task" {
  description = "Conrol plane task definition."
  type = object({
    iam-role-arn    = optional(string)
    image           = string
    command         = optional(list(string))
    secrets         = optional(list(map(string)))
    environment     = optional(list(map(string)))
    cpu             = optional(string)
    memory          = optional(string)
    cloudwatch-logs = optional(bool)
    ecr             = optional(bool)
  })
  default = {
    iam-role-arn    = ""
    image           = "gatlingcorp/control-plane:latest"
    command         = []
    secrets         = []
    environment     = []
    cpu             = "1024"
    memory          = "3072"
    cloudwatch-logs = true
    ecr             = false
  }
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
  type    = map(any)
  default = {}
}

variable "extra-content" {
  type    = map(any)
  default = {}
}
