variable "aws_region" {
  type = string
}

variable "name" {
  description = "Name of the control plane."
  type        = string
}

variable "description" {
  description = "Description of the control plane."
  type        = string
}

variable "token-secret-arn" {
  description = "Secret Token ARN of the control plane"
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
}

variable "task" {
  description = "Conrol plane task definition."
  type = object({
    iam-role-arn = string
    init = object({
      image = string
    })
    image           = string
    command         = list(string)
    secrets         = list(map(string))
    environment     = list(map(string))
    cpu             = string
    memory          = string
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
