locals {
  private-package = {
    type    = "gcp"
    bucket  = var.bucket
    path    = var.path
    project = var.project
    upload  = var.upload
    server  = var.server
  }
}
