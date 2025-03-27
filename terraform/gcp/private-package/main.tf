locals {
  private-package = {
    type    = "gcp"
    project = var.project
    bucket  = var.bucket
    path    = var.path
    upload  = var.upload
    server  = var.server
  }
}
