data "azurerm_storage_account" "gatling_storage_account" {
  name                = var.storage-account-name
  resource_group_name = var.resource-group-name
}
