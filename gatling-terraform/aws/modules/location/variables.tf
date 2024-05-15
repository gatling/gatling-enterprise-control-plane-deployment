variable "id" {
  type        = string
  description = "ID of the location."
}

variable "description" {
  type        = string
  description = "Description of the location."
}

variable "region" {
  type        = string
  description = "Region of the location."
}

variable "java_version" {
  type        = string
  description = "Java version of the location."
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group ids of the location."
}

variable "instance_type" {
  type        = string
  description = "Instance type of the location."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids of the location."
}
