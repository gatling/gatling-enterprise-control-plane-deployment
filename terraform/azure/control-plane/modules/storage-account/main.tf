data "azurerm_storage_account" "gatling_storage_account" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_storage_share" "gatling_storage_share" {
  name                 = "${var.storage_account_name}-fs"
  storage_account_name = var.storage_account_name
  quota                = 50
}

resource "local_file" "json_file" {
  filename = var.conf_share_file_name
  content = jsonencode({
    control-plane : merge(var.extra_content, {
      token : var.token
      description : var.description
      locations : [for location in var.locations : location.conf]
      repository : length(var.private_package) > 0 ? var.private_package.conf : {}
    })
  })
}

resource "azurerm_storage_share_file" "gatling_storage_share_file" {
  name             = var.conf_share_file_name
  storage_share_id = azurerm_storage_share.gatling_storage_share.id
  source           = local_file.json_file.filename

  lifecycle {
    replace_triggered_by = [
      local_file.json_file.content
    ]
  }

  depends_on = [local_file.json_file]
}