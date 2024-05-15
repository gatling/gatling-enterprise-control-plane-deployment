locals {
  private_package = {
        type : "aws",
        bucket : var.bucket,
        path : var.path
      }
}
