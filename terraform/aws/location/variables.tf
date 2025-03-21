variable "id" {
  type        = string
  description = "ID of the location."

  validation {
    condition     = can(regex("^prl_[0-9a-z_]{1,26}$", var.id))
    error_message = "Private location ID must be prefixed by 'prl_', contain only numbers, lowercase letters, and underscores, and be at most 30 characters long."
  }
}

variable "description" {
  type        = string
  description = "Description of the location."
  default     = "Private Location on AWS"
}

variable "region" {
  type        = string
  description = "Region of the location."

  validation {
    condition     = length(var.region) > 0
    error_message = "Region must not be empty."
  }
}

variable "engine" {
  type        = string
  description = "Engine of the location determining the compatible package formats (JavaScript or JVM)."
  default     = "classic"
}

variable "instance-type" {
  type        = string
  description = "Instance type of the location."
  default     = "c7i.xlarge"
}

variable "spot" {
  type        = bool
  description = "Flag to enable spot instances."
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
  type        = list(string)
  description = "Subnet ids of the location."

  validation {
    condition     = length(var.subnets) > 0
    error_message = "Subnets must not be empty."
  }
}

variable "security-groups" {
  type        = list(string)
  description = "Security group ids of the location."

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
  type        = list(string)
  description = "Assign elastic IPs to your Locations. You will only be able to deploy a number of load generators up to the number of Elastic IP addresses you have configured."
  default     = []
}

variable "profile-name" {
  type        = string
  description = "Profile name to be assigned to the Location."
  default     = ""
}

variable "iam-instance-profile" {
  type        = string
  description = "IAM instance profile to be assigned to the Location."
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
  type    = map(any)
  default = {}
}
