locals {
  private_package = {
    type : "azure"
    storage-account : var.storage-account-name
    container : var.control-plane-name
    path : var.path
    upload  : var.upload
  }
}
