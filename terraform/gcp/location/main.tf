locals {
  location = {
    id                = var.id
    description       = var.description
    type              = "gcp"
    zone              = var.zone
    instance-template = var.instance_template
    machine = {
      type        = var.machine_type
      engine      = var.engine
      preemptible = var.preemptible
      image = {
        type   = var.image_type
        java   = var.java_version
        id     = var.image_id
        family = var.image_family
      }
      disk              = var.disk
      network-interface = var.network_interface
    }
    project           = var.project
    system-properties = var.system_properties
    java-home         = var.java_home
    jvm-options       = var.jvm_options
    enterprise-cloud  = var.enterprise_cloud
  }
}
