locals {
  private_package = {
    type : "azure",
    storage-account : var.storage_account_name
    container : var.container_name
    path : var.path
    upload : {
      directory = var.uploadDir
    }
    server : {
      port : var.port
      bindAddress : var.bindAddress
      certificate : length(var.certPath) > 0 ? {
        path : var.certPath
        password : var.certPassword
      } : null
    }
  }
}
