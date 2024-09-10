output "storage_account_primary_access_key" {
  value       = data.azurerm_storage_account.gatling_storage_account.primary_access_key
  description = "Primary key for the storage account"
}

output "storage_share_name" {
  value       = azurerm_storage_share.gatling_storage_share.name
  description = "Storage share name used to store the configuration."
}