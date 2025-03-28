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

  validation {
    condition     = contains(["classic", "javascript"], var.engine)
    error_message = "The engine must be either 'classic' or 'javascript'."
  }
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
    type = optional(string, "certified")
    java = optional(string, "latest")
    id   = optional(string)
  })
  default = {}

  validation {
    condition     = var.ami.type != "custom" || var.ami.id != null
    error_message = "If ami.type is 'custom', then ami.id must be specified."
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

  validation {
    condition     = !(var.auto-associate-public-ipv4 && length(var.elastic-ips) > 0)
    error_message = "When elastic_ips are provided, auto-associate-public-ipv4 must be false."
  }
}

variable "profile-name" {
  description = "Profile name to be assigned to the Location."
  type        = string
  default     = null
}

variable "iam-instance-profile" {
  description = "IAM instance profile to be assigned to the Location."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to be assigned to the Location."
  type        = map(string)
  default     = {}
}

variable "tags-for" {
  description = "Tags to be assigned to the resources of the Location."
  type = object({
    instance          = optional(map(string), {})
    volume            = optional(map(string), {})
    network-interface = optional(map(string), {})
  })
  default = {}
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
