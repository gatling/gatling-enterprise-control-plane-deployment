variable "id" {
  type        = string
  description = "ID of the location."
  default = "prl_private_location_example"
}

variable "description" {
  type        = string
  description = "Description of the location."
  default = "Private Location on AWS"
}

variable "region" {
  type        = string
  description = "Region of the location."
}

variable "instance_type" {
  type        = string
  description = "Instance type of the location."
  default = "c6i.xlarge"
}

variable "spot" {
  type        = bool
  description = "Flag to enable spot instances."
  default = false
}

variable "ami_type" {
  type        = string
  description = "AMI type of the location."
  default = "certified"
}

variable "java_version" {
  type        = string
  description = "Java version of the location."
  default = "latest"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids of the location."
}


variable "security_group_ids" {
  type        = list(string)
  description = "Security group ids of the location."
}

variable "elastic_ips" {
  type        = list(string)
  description = "Assign elastic IPs to your Locations. You will only be able to deploy a number of load generators up to the number of Elastic IP addresses you have configured."
  default = []
}

variable "profile_name" {
  type        = string
  description = "Profile name to be assigned to the Location"
  default = ""
}

variable "iam_instance_profile" {
  type        = string
  description = "IAM instance profile to be assigned to the Location"
  default = ""
}

variable "tags" {
  description = "Tags to be assigned to the Location."
  type        = map(string)
  default     = {
    # ExampleKey = "ExampleValue"
  }
}

variable "tags_for" {
  description = "Tags to be assigned to the resources of the Location."
  type        = map(map(string))
  default     = {
        instance : {
          # ExampleKey = "ExampleValue"
        }
        volume : {
          # ExampleKey = "ExampleValue"
        }
        network-interface : {
          # ExampleKey = "ExampleValue"
        }
      }
}

variable "system_properties" {
  description = "System properties to be assigned to the Location."
  type        = map(string)
  default     = {
    # ExampleKey = "ExampleValue"
  }
}

variable "java_home" {
  description = "Overwrite JAVA_HOME definition."
  type        = string
  default     = "/usr/lib/jvm/zulu"
}

variable "jvm_options" {
  description = "Overwrite JAVA_HOME definition."
  type        = list(string)
  default     = []
}