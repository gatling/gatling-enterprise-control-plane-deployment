locals {
  conf-file-name = "control-plane.conf"
}

data "azurerm_storage_account" "gatling_storage_account" {
  name                = var.storage-account-name
  resource_group_name = var.resource-group-name
}

resource "azurerm_storage_share" "gatling_storage_share" {
  name               = "${var.storage-account-name}-file-share"
  storage_account_id = data.azurerm_storage_account.gatling_storage_account.id
  quota              = 50
}

resource "local_file" "json_file" {
  filename = local.conf-file-name
  content  = <<-EOF
    control-plane {
      token = $${?CONTROL_PLANE_TOKEN}
      description = "${var.description}"
      enterprise-cloud = ${jsonencode(var.enterprise-cloud)}
      locations = [%{for location in var.locations} ${jsonencode(location.conf)}, %{endfor}]
      %{if length(var.private-package) > 0}repository = ${jsonencode(var.private-package.conf)}%{endif}
      %{for key, value in var.extra-content}${key} = "${value}"%{endfor}
    }
  EOF
}

resource "azurerm_storage_share_file" "gatling_storage_share_file" {
  name             = local.conf-file-name
  storage_share_id = azurerm_storage_share.gatling_storage_share.url
  source           = local_file.json_file.filename

  lifecycle {
    replace_triggered_by = [
      local_file.json_file.content
    ]
  }

  depends_on = [local_file.json_file]
}
