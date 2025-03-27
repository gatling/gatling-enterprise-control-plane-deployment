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
  default     = "Private Location on Azure"
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

variable "image" {
  description = "Image of the location."
  type = object({
    type  = optional(string, "certified")
    java  = optional(string, "latest")
    image = optional(string)
  })
  default = {}

  validation {
    condition     = var.image.type != "custom" || var.image.image != null
    error_message = "If image.type is 'custom', then image.image must be specified."
  }
}

variable "subscription" {
  description = "Subscription of the location."
  type        = string

  validation {
    condition     = length(var.subscription) > 0
    error_message = "Subscription must not be empty."
  }
}

variable "network-id" {
  description = "Network id with the following format /subscriptions/<SubscriptionUUID>/resourceGroups/<ResourceGroup>/providers/Microsoft.Network/virtualNetworks/<VNet>."
  type        = string

  validation {
    condition     = length(var.network-id) > 0
    error_message = "Virtual network name must not be empty."
  }
}

variable "subnet-name" {
  description = "Subnet name of the location."
  type        = string

  validation {
    condition     = length(var.subnet-name) > 0
    error_message = "Subnet name must not be empty."
  }
}

variable "size" {
  description = "Virtual machine size of the location."
  type        = string
  default     = "Standard_A4_v2"
}

variable "associate-public-ip" {
  description = "Flag to enable public IP association."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to be assigned to the Location."
  type        = map(string)
  default     = {}
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
  description = "Overwrite JAVA_HOME definition."
  type        = list(string)
  default     = []
}

variable "enterprise-cloud" {
  type    = map(any)
  default = {}
}
