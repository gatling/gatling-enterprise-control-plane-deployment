locals {
  private_package = {
    type = "gcp"
    bucket = var.bucket
    path = var.path
    project = var.project
  }
}