locals {
  private_package = {
    type : "azure",
    storage-account : var.storage_account_name
    container : var.container_name
    path : var.path
  }
}
