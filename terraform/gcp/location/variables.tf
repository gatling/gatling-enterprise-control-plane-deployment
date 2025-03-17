variable "id" {
  description = "ID of the location."
  type        = string

  validation {
    condition     = can(regex("^prl_[0-9a-z_]{1,26}$", var.id))
    error_message = "Private location ID must be prefixed by 'prl_', contain only numbers, lowercase letters, and underscores, and be at most 30 characters long."
  }
}

variable "project" {
  description = "Project id on GCP."
  type        = string

  validation {
    condition     = length(var.project) > 0
    error_message = "Project must not be empty."
  }
}

variable "zone" {
  description = "Zone of the location."
  type        = string

  validation {
    condition     = length(var.zone) > 0
    error_message = "Zone must not be empty."
  }
}

variable "description" {
  description = "Description of the location."
  type        = string
  default     = "Private Location on GCP"
}

variable "instance-template" {
  description = "Instance template defining configuration settings for virtual machine."
  type        = string
  default     = null
}

variable "machine" {
  description = "Machine configuration for load testing infrastructure"
  type = object({
    type        = string
    preemptible = optional(bool)
    engine      = string
    image = object({
      type    = string
      java    = optional(string)
      project = optional(string)
      family  = optional(string)
      id      = optional(string)
    })
    disk = object({
      sizeGb = number
    })
    network-interface = optional(object({
      network          = optional(string)
      subnetwork       = optional(string)
      with-external-ip = optional(bool)
    }))
  })

  validation {
    condition     = contains(["classic", "javascript"], var.machine.engine)
    error_message = "The engine must be either 'classic' or 'javascript'."
  }

  validation {
    condition     = contains(["certified", "custom"], var.machine.image.type)
    error_message = "The image type must be either 'certified' or 'custom'."
  }

  validation {
    condition = var.machine.image.type != "custom" || (
      var.machine.image.project != null &&
      (var.machine.image.id != null || var.machine.image.family != null)
    )
    error_message = "If image.type is 'custom', then project must be defined and either id or family must be specified."
  }

  validation {
    condition     = var.machine.disk.sizeGb >= 20
    error_message = "Disk sizeGb must be greater than or equal to 20."
  }

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]+$", var.machine.type))
    error_message = "Machine type must start with a letter and contain only lower-case letters, digits, or hyphens."
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
  description = "Define JVM options."
  type        = list(string)
  default     = []
}

variable "enterprise-cloud" {
  type    = map(any)
  default = {}
}
