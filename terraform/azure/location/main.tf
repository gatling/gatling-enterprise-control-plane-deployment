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
    network-id : var.network-id
    subnet-name : var.subnet-name
    associate-public-ip : var.associate-public-ip
    tags : var.tags
    system-properties : var.system-properties
    java-home : var.java-home
    jvm-options : var.jvm-options
    enterprise-cloud : var.enterprise-cloud
  }
}
