locals {
  private-package = {
    type : "aws"
    bucket : var.bucket
    path : var.path
    upload : var.upload
  }
}
