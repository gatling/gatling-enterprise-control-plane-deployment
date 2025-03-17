variable "role-id" {
  description = "The ID of the custom role"
  type        = string
  default     = "control_plane_role"
}

variable "role-title" {
  description = "The title of the custom role"
  type        = string
  default     = "Gatling Control Plane Role"
}

variable "role-description" {
  description = "The description of the custom role"
  type        = string
  default     = "A custom role with permissions to spawn and terminate Gatling load injectors and access secret manager versions."
}

variable "service-account-id" {
  description = "The ID of the service account"
  type        = string
  default     = "gatling-control-plane-sa"
}

variable "service-account-display-name" {
  description = "The display name of the service account"
  type        = string
  default     = "Gatling Control Plane Service Account"
}

variable "locations" {
  description = "JSON configuration for the private locations."
  type        = list(any)
}

variable "private-package" {
  description = "JSON configuration for the Private Package."
  type        = map(any)
}
