data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "container_app_policy" {
  key_vault_id       = "${data.azurerm_subscription.current.id}/resourceGroups/${var.resource-group-name}/providers/Microsoft.KeyVault/vaults/${var.vault-name}"
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = var.container.identity[0].principal_id
  secret_permissions = ["Get"]
}

resource "azurerm_role_definition" "gatling_custom_role" {
  name        = "Gatling Role"
  scope       = data.azurerm_subscription.current.id
  description = "Role for Gatling Control plane permissions."

  permissions {
    actions = concat([
      "Microsoft.MarketplaceOrdering/agreements/offers/plans/read",
      "Microsoft.MarketplaceOrdering/agreements/offers/plans/sign/action",
      "Microsoft.Resources/subscriptions/resourceGroups/read",
      "Microsoft.Resources/subscriptions/resourceGroups/write",
      "Microsoft.Resources/subscriptions/resourceGroups/delete",
      "Microsoft.MarketplaceOrdering/offertypes/publishers/offers/plans/agreements/read",
      "Microsoft.MarketplaceOrdering/offertypes/publishers/offers/plans/agreements/write",
      "Microsoft.Network/virtualNetworks/read",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/publicIPAddresses/write",
      "Microsoft.Network/networkInterfaces/write",
      "Microsoft.Network/networkInterfaces/join/action",
      "Microsoft.Compute/galleries/images/versions/read",
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.Compute/virtualMachines/write"
      ], var.storage ? [
      "Microsoft.Storage/storageAccounts/read",
      "Microsoft.Storage/storageAccounts/listkeys/action"
    ] : [])
  }
}

resource "azurerm_role_assignment" "gatling_custom_role_assignment" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = azurerm_role_definition.gatling_custom_role.role_definition_resource_id
  principal_id       = var.container.identity[0].principal_id
  depends_on         = [var.container]
}

resource "azurerm_role_assignment" "gatling_storage_contributor" {
  count                = length(var.private-package) > 0 ? 1 : 0
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.container.identity[0].principal_id
  depends_on           = [var.container]
}
