locals {
  private_package = {
    type : "azure",
    storage-account : var.storage_account_name
    container : var.control_plane_name
    path : var.path
    upload  = var.upload
    server  = var.server
  }
}
