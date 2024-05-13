variable "cp_name" {
  type        = string
  description = "Name of the control plane."
}

variable "cp_config_content" {
  type        = string
  description = "JSON encoded string of the control plane configuration."
}