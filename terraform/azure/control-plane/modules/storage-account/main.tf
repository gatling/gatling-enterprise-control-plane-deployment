data "azurerm_storage_account" "gatling_storage_account" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_storage_share" "gatling_storage_share" {
  name               = "${var.storage_account_name}-fs"
  storage_account_id = data.azurerm_storage_account.gatling_storage_account.id
  quota              = 50
}

resource "local_file" "json_file" {
  filename = var.conf_share_file_name
  content = <<-EOF
    control-plane {
      token = $${?CONTROL_PLANE_TOKEN}
      description = "${var.description}"
      enterprise-cloud = { %{for key, value in var.enterprise_cloud} ${key} = "${value}" %{endfor} }
      locations = [ %{for location in var.locations} ${jsonencode(location.conf)}, %{endfor} ]
      %{if length(var.private_package) > 0}repository = ${jsonencode(var.private_package.conf)}%{endif}
      %{for key, value in var.extra_content}${key} = "${value}"%{endfor}
    }
  EOF
}

resource "azurerm_storage_share_file" "gatling_storage_share_file" {
  name             = var.conf_share_file_name
  storage_share_id = azurerm_storage_share.gatling_storage_share.url
  source           = local_file.json_file.filename

  lifecycle {
    replace_triggered_by = [
      local_file.json_file.content
    ]
  }

  depends_on = [local_file.json_file]
}
