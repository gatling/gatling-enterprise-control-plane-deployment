data "aws_s3_bucket" "s3_conf" {
  bucket = var.name
}

resource "aws_s3_object" "conf" {
  bucket = data.aws_s3_bucket.s3_conf.id
  key    = "control-plane.conf"
  content_type = "application/json"
  content = jsonencode({
    control-plane : {
      token : var.token,
      description : "my control plane description",
      locations :  [for location in var.locations : location.conf]
      repository : length(var.private_package) > 0 ? var.private_package.conf : {}
    }
  })
}