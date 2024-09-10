variable "id" {
  type        = string
  description = "ID of the location."
  default     = "prl_private_location_example"
}

variable "description" {
  type        = string
  description = "Description of the location."
  default     = "Private Location on Azure"
}

variable "region" {
  type        = string
  description = "Region of the location."
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

variable "size" {
  type        = string
  description = "Virtual machine size of the location."
  default     = "Standard_A4_v2"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "virtual_network" {
  type        = string
  description = "Virtual network name."
}

variable "subnet_name" {
  type        = string
  description = "Subnet name of the location."
}

variable "associate_public_ip" {
  type        = bool
  description = "Flag to enable public IP association."
  default     = false
}

variable "system_properties" {
  description = "System properties to be assigned to the Location."
  type        = map(string)
  default     = {}
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