variable "token-secret-arn" {
  description = "Control plane secret token ARN."
  type        = string
}

variable "aws_region" {
  type = string
}

variable "name" {
  description = "Control Plane role name."
  type        = string
}

variable "locations" {
  description = "JSON configuration for the locations."
  type        = list(any)
}

variable "private-package" {
  description = "JSON configuration for the private packages."
  type        = map(any)
}

variable "git" {
  description = "Control plane git configuration."
  type = object({
    host = string
    credentials = object({
      username         = string
      token-secret-arn = string
    })
    ssh = object({
      private-key-secret-arn = string
    }),
    cache = object({
      paths = list(string)
    })
  })
}

variable "task" {
  description = "Control plane task definition."
  type = object({
    secrets         = list(map(string))
    cloudwatch-logs = bool
    ecr             = bool
    init = object({
      secrets = list(map(string))
    })
  })
}
