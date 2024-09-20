variable "id" {
  type        = string
  description = "ID of the location."
  default     = "prl_private_location_example"
}

variable "project" {
  type        = string
  description = "Project id on GCP."
}

variable "zone" {
  type        = string
  description = "Zone of the location."
}

variable "engine" {
  type        = string
  description = "Engine of the location determining the compatible package formats (JavaScript or JVM)."
  default     = "classic"
}

variable "description" {
  type        = string
  description = "Description of the location."
  default     = "Private Location on GCP"
}

variable "instance_template" {
  type        = string
  description = "Instance template defining configuration settings for virtual machine."
  default     = null
}

variable "machine_type" {
  type        = string
  description = "Machine type of the location."
  default     = "c3-highcpu-4"
}

variable "preemptible" {
  type        = bool
  description = "Configure load generators instances as preemptible or not."
  default     = false
}

variable "image_type" {
  type        = string
  description = "Image type of the location."
  default     = "certified"
}

variable "java_version" {
  type        = string
  description = "Java version of the location."
  default     = "latest"
}

variable "network_interface" {
  description = "Network interface properties to be assigned to the Location."
  type        = map(any)
  default = {}
}

variable "disk" {
  description = "Disk size in GB of the control plane."
  type        = map(any)
  default     = {
    sizeGb = 20
  }
}

variable "system_properties" {
  description = "System properties to be assigned to the Location."
  type        = map(string)
  default = {}
}

variable "java_home" {
  description = "Overwrite JAVA_HOME definition."
  type        = string
  default     = null
}

variable "jvm_options" {
  description = "Overwrite JAVA_HOME definition."
  type        = list(string)
  default     = []
}