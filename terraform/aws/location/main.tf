locals {
  location = {
    id : var.id,
    description : var.description,
    type : "aws",
    region : var.region,
    engine : var.engine,
    ami : {
      type : var.ami_type,
      java : var.java_version
      id  : var.ami_id
    },
    subnets : var.subnet_ids,
    security-groups : var.security_group_ids,
    instance-type : var.instance_type,
    spot : var.spot,
    auto-associate-public-ipv4: var.auto_associate_public_ipv4,
    elastic-ips : var.elastic_ips,
    profile_name : var.profile_name,
    iam-instance-profile : var.iam_instance_profile,
    tags : var.tags,
    tags-for : var.tags_for,
    system-properties : var.system_properties,
    java-home : var.java_home,
    jvm-options : var.jvm_options,
    enterprise-cloud : var.enterprise_cloud
  }
}
