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
  description = "Control plane task definition."
  type = object({
    iam-role-arn = string
    init = object({
      image = string
      command = list(string)
      environment = list(map(string))
      secrets = list(map(string))
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

variable "git" {
  description = "Control plane git configuration."
  type = object({
    host = string
    credentials = object({
      username            = string
      token-secret-arn = string
    })
    ssh = object({
      private-key-secret-arn = string
    }),
    cache = object({
      paths   = list(string)
    })
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

variable "certificates" {
  description = <<-EOT
    Content of custom CA certificates in PEM format to be added to the Java truststore.
    Use file() function to load from a file: certificates = file("path/to/cert.pem")
    Multiple certificates can be included in a single PEM file.
    Leave empty to skip certificate installation.
  EOT
  type        = string
  default     = ""
}
variable "server" {
  description = "Control Plane Repository Server configuration."
  type = object({
    port        = number
    bindAddress = string
    certificate = object({
      path     = string
      password = string
    })
  })
}
