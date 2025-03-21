variable "aws_region" {
  type        = string
}

variable "name" {
  type        = string
  description = "Name of the control plane."
}

variable "description" {
  type        = string
  description = "Description of the control plane."
}

variable "token-secret-arn" {
  type        = string
  description = "Secret Token ARN of the control plane"
}

variable "subnets" {
  type        = list(string)
  description = "The subnet IDs for the control plane."
}

variable "security-groups" {
  type        = list(string)
  description = "Security group IDs to be used with the control plane."
}

variable "task" {
  description = "Conrol plane task definition."
  type = object({
    iam-role-arn    = string
    image           = string
    command         = optional(list(string))
    secrets         = optional(list(map(string)))
    environment     = optional(list(map(string)))
    cpu             = optional(string)
    memory          = optional(string)
    cloudwatch-logs = bool
    ecr             = bool
  })
}

variable "locations" {
  description = "JSON configuration for the locations."
  type        = list(any)
}

variable "private-package" {
  description = "JSON configuration for the Private Package."
  type        = map(any)
}

variable "enterprise-cloud" {
  type = map(any)
}

variable "extra-content" {
  type = map(any)
}
