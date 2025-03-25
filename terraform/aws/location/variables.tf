variable "id" {
  description = "ID of the location."
  type        = string

  validation {
    condition     = can(regex("^prl_[0-9a-z_]{1,26}$", var.id))
    error_message = "Private location ID must be prefixed by 'prl_', contain only numbers, lowercase letters, and underscores, and be at most 30 characters long."
  }
}

variable "description" {
  description = "Description of the location."
  type        = string
  default     = "Private Location on AWS"
}

variable "region" {
  description = "Region of the location."
  type        = string

  validation {
    condition     = length(var.region) > 0
    error_message = "Region must not be empty."
  }
}

variable "engine" {
  description = "Engine of the location determining the compatible package formats (JavaScript or JVM)."
  type        = string
  default     = "classic"
}

variable "instance-type" {
  description = "Instance type of the location."
  type        = string
  default     = "c7i.xlarge"
}

variable "spot" {
  description = "Flag to enable spot instances."
  type        = bool
  default     = false
}

variable "ami" {
  description = "Image of the location."
  type = object({
    type = string
    java = optional(string)
    id   = optional(string)
  })
  default = {
    type = "certified"
  }
}

variable "subnets" {
  description = "Subnet ids of the location."
  type        = list(string)

  validation {
    condition     = length(var.subnets) > 0
    error_message = "Subnets must not be empty."
  }
}

variable "security-groups" {
  description = "Security group ids of the location."
  type        = list(string)

  validation {
    condition     = length(var.security-groups) > 0
    error_message = "Security groups must not be empty."
  }
}

variable "auto-associate-public-ipv4" {
  type        = bool
  description = "Automatically associate a public IPv4."
  default     = true
}

variable "elastic-ips" {
  description = "Assign elastic IPs to your Locations. You will only be able to deploy a number of load generators up to the number of Elastic IP addresses you have configured."
  type        = list(string)
  default     = []
}

variable "profile-name" {
  description = "Profile name to be assigned to the Location."
  type        = string
  default     = ""
}

variable "iam-instance-profile" {
  description = "IAM instance profile to be assigned to the Location."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to be assigned to the Location."
  type        = map(string)
  default     = {}
}

variable "tags-for" {
  description = "Tags to be assigned to the resources of the Location."
  type = object({
    instance          = map(string)
    volume            = map(string)
    network-interface = map(string)
  })
  default = {
    instance : {}
    volume : {}
    network-interface : {}
  }
}

variable "system-properties" {
  description = "System properties to be assigned to the Location."
  type        = map(string)
  default     = {}
}

variable "java-home" {
  description = "Overwrite JAVA_HOME definition."
  type        = string
  default     = null
}

variable "jvm-options" {
  description = "Pass JVM Options."
  type        = list(string)
  default     = []
}
variable "enterprise-cloud" {
  description = "Enterprise Cloud network settings: http proxy, fwd proxy, etc."
  type        = map(any)
  default     = {}
}
