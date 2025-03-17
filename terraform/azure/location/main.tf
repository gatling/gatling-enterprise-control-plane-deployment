locals {
  location = {
    id : var.id
    description : var.description
    type : "azure"
    region : var.region
    size : var.size
    engine : var.engine
    image : var.image
    subscription : var.subscription
    network-id : var.network_id
    subnet-name : var.subnet_name
    associate-public-ip : var.associate_public_ip
    tags : var.tags
    system-properties : var.system_properties
    java-home : var.java_home
    jvm-options : var.jvm_options
    enterprise-cloud : var.enterprise_cloud
  }
}
