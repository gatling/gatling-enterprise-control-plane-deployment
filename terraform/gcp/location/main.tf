locals {
  location = {
    id                = var.id
    description       = var.description
    type              = "gcp"
    zone              = var.zone
    instance-template = var.instance_template
    machine           = var.machine
    project           = var.project
    system-properties = var.system_properties
    java-home         = var.java_home
    jvm-options       = var.jvm_options
    enterprise-cloud  = var.enterprise_cloud
  }
}
