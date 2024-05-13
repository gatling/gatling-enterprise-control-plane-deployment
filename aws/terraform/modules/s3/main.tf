resource "aws_s3_bucket" "cp_s3_bucket" {
  bucket = "${var.cp_name}-s3"
  tags = {
    Name = "Control Plane Configuration Bucket"
  }
}

resource "aws_s3_object" "cp_config" {
  bucket = aws_s3_bucket.cp_s3_bucket.id
  key    = "control-plane.conf"
  content = var.cp_config_content
  content_type = "application/json"
}