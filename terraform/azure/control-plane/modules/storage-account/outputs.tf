output "primary-access-key" {
  value       = data.azurerm_storage_account.gatling_storage_account.primary_access_key
  description = "Primary key for the storage account"
}

output "share-name" {
  value       = azurerm_storage_share.gatling_storage_share.name
  description = "Storage share name used to store the configuration."
}
