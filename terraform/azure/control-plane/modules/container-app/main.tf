resource "azurerm_container_app_environment" "gatling_container_env" {
  name                = "${var.name}-env"
  resource_group_name = var.resource_group_name
  location            = var.region
}

resource "azurerm_container_app_environment_storage" "gatling_container_env_storage" {
  name                         = "control-plane-conf"
  container_app_environment_id = azurerm_container_app_environment.gatling_container_env.id
  account_name                 = var.storage_account_name
  share_name                   = var.storage_share_name
  access_key                   = var.storage_account_primary_access_key
  access_mode                  = "ReadOnly"

  depends_on = [
    azurerm_container_app_environment.gatling_container_env
  ]
}

resource "azurerm_container_app" "gatling_container" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.gatling_container_env.id
  revision_mode                = "Single"

  identity {
    type = "SystemAssigned"
  }

  dynamic "ingress" {
    for_each = length(var.private_package) > 0 ? [1] : []
    content {
      external_enabled = true
      target_port      = 8080
      traffic_weight {
        percentage      = 100
        latest_revision = true
      }
    }
  }

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name    = "control-plane"
      image   = var.image
      cpu     = 1.0
      memory  = "2Gi"
      command = var.command

      volume_mounts {
        name = "control-plane-conf"
        path = "/app/conf"
      }
    }

    volume {
      name         = "control-plane-conf"
      storage_name = "control-plane-conf"
      storage_type = "AzureFile"
    }
  }

  depends_on = [
    azurerm_container_app_environment.gatling_container_env,
    azurerm_container_app_environment_storage.gatling_container_env_storage
  ]
}
