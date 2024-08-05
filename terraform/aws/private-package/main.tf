locals {
  private_package = {
    type : "aws",
    bucket : var.bucket,
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
