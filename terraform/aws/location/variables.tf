variable "id" {
  type        = string
  description = "ID of the location."
  default     = "prl_private_location_example"
}

variable "description" {
  type        = string
  description = "Description of the location."
  default     = "Private Location on AWS"
}

variable "region" {
  type        = string
  description = "Region of the location."
}

variable "engine" {
  type        = string
  description = "Engine of the location determining the compatible package formats (JavaScript or JVM)."
  default     = "classic"
}

variable "instance_type" {
  type        = string
  description = "Instance type of the location."
  default     = "c7i.xlarge"
}

variable "spot" {
  type        = bool
  description = "Flag to enable spot instances."
  default     = false
}

variable "ami_type" {
  type        = string
  description = "AMI type of the location."
  default     = "certified"
}

variable "ami_id" {
  type        = string
  description = "Custom AMI id of the location."
  default     = ""
}

variable "java_version" {
  type        = string
  description = "Java version of the location."
  default     = "latest"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids of the location."
}


variable "security_group_ids" {
  type        = list(string)
  description = "Security group ids of the location."
}

variable "auto_associate_public_ipv4" {
  type        = bool
  description = "Automatically associate a public IPv4."
  default     = true
}

variable "elastic_ips" {
  type        = list(string)
  description = "Assign elastic IPs to your Locations. You will only be able to deploy a number of load generators up to the number of Elastic IP addresses you have configured."
  default     = []
}

variable "profile_name" {
  type        = string
  description = "Profile name to be assigned to the Location."
  default     = ""
}

variable "iam_instance_profile" {
  type        = string
  description = "IAM instance profile to be assigned to the Location."
  default     = ""
}

variable "tags" {
  description = "Tags to be assigned to the Location."
  type        = map(string)
  default     = {}
}

variable "tags_for" {
  description = "Tags to be assigned to the resources of the Location."
  type        = map(map(string))
  default = {
    instance : {}
    volume : {}
    network-interface : {}
  }
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
  description = "Pass JVM Options."
  type        = list(string)
  default     = []
}
variable "enterprise_cloud" {
  type    = map(any)
  default = {}
}
