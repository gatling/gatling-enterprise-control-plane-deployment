locals {
  location = {
        id : var.id,
        description : var.description,
        type : "aws",
        region : var.region,
        ami : {
          type : "certified",
          java : var.java_version
        },
        security-groups : var.security_group_ids,
        instance-type : var.instance_type,
        subnets : var.subnet_ids,
  }
}
