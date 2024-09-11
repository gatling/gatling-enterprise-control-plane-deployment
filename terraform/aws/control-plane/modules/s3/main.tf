data "aws_s3_bucket" "s3_conf" {
  bucket = var.name
}

locals {
  base_content = {
    token        = var.token
    description  = var.description
    locations    = [for location in var.locations : location.conf]
  }

  full_content = {
    control-plane = merge(
      var.extra_content,
      local.base_content,
      length(var.private_package) > 0 ? {
        repository = var.private_package.conf
      } : {}
    )
  }

  json_content = jsonencode(local.full_content)
}

resource "aws_s3_object" "conf" {
  bucket       = data.aws_s3_bucket.s3_conf.id
  key          = var.object_name
  content_type = "application/json"
  content      = local.json_content
}