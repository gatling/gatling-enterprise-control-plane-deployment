locals {
  location = {
    id : var.id
    description : var.description
    type : "aws"
    region : var.region
    engine : var.engine
    ami : var.ami
    subnets : var.subnets
    security-groups : var.security-groups
    instance-type : var.instance-type
    spot : var.spot
    auto-associate-public-ipv4 : var.auto-associate-public-ipv4
    elastic-ips : var.elastic-ips
    profile-name : var.profile-name
    iam-instance-profile : var.iam-instance-profile
    tags : var.tags
    tags-for : var.tags-for
    system-properties : var.system-properties
    java-home : var.java-home
    jvm-options : var.jvm-options
    enterprise-cloud : var.enterprise-cloud
  }
}
