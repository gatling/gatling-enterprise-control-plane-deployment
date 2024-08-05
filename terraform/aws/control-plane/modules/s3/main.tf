data "aws_s3_bucket" "s3_conf" {
  bucket = var.name
}

resource "aws_s3_object" "conf" {
  bucket = data.aws_s3_bucket.s3_conf.id
  key    = var.object_name
  content_type = "application/json"
  content = jsonencode({
    control-plane : merge(var.extra_content, {
      token : var.token,
      description : var.description,
      locations :  [for location in var.locations : location.conf]
      repository : length(var.private_package) > 0 ? var.private_package.conf : null
    })
  })
}
