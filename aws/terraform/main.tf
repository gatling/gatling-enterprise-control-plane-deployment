terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.48.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

module "iam" {
  source = "./modules/iam"
  cp_name = var.cp_name
  pp_flag = var.pp_flag
}

module "s3" {
  source = "./modules/s3"
  cp_name = var.cp_name
  cp_config_content = jsonencode({
    control-plane : {
      token : var.cp_token,
      description : "my control plane description",
      locations : [for location in var.locations : {
        id : location.id,
        description : location.description,
        type : "aws",
        region : location.region,
        ami : {
          type : "certified",
          java : location.java_version
        },
        security-groups : location.security_group_ids,
        instance-type : location.instance_type,
        subnets : location.subnet_ids,
        tags : {},
        tags-for : {
          instance : {},
          volume : {},
          network-interface : {}
        },
        system-properties : {},
        #java-home: "/usr/lib/jvm/zulu",
        #jvm-options: ["-Xmx4G", "-Xms512M"]
      }],
      repository : var.pp_flag ? {
        type : "aws",
        bucket : "${var.cp_name}-s3",
        path : var.pp_s3_dir
      } : {}
    }
  })
}

module "ecs" {
  source = "./modules/ecs"
  cp_name = var.cp_name
  cp_iam_role_arn = module.iam.cp_iam_role_arn
  cp_subnet_ids  = var.cp_subnet_ids
  cp_security_group_ids  = var.cp_security_group_ids
  pp_alb_target_group_arn = var.pp_flag ? module.alb.pp_alb_target_group_arn : ""
  pp_alb_listener_id = var.pp_flag ? module.alb.pp_alb_listener_id : ""
  pp_flag = var.pp_flag
}

module "alb" {
  source = "./modules/alb"
  cp_name = var.cp_name
  pp_vpc = var.pp_vpc
  cp_subnet_ids = var.cp_subnet_ids
  pp_s3_dir = var.pp_s3_dir
  pp_alb_security_group_ids = var.pp_alb_security_group_ids
  pp_flag = var.pp_flag
}