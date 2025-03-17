locals {
  location = {
    id                = var.id
    description       = var.description
    type              = "gcp"
    project           = var.project
    zone              = var.zone
    instance-template = var.instance-template
    machine           = var.machine
    system-properties = var.system-properties
    java-home         = var.java-home
    jvm-options       = var.jvm-options
    enterprise-cloud  = var.enterprise-cloud
  }
}
