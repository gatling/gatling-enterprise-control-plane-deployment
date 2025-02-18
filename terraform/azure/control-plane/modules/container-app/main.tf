locals {
  path        = "/app/conf"
  volume_name = "control-plane-conf"
  secret_name = "token-secret-id"
}

resource "azurerm_container_app_environment" "gatling_container_env" {
  name                = "${var.name}-env"
  resource_group_name = var.resource_group_name
  location            = var.region
}

resource "azurerm_container_app_environment_storage" "gatling_container_env_storage" {
  name                         = local.volume_name
  container_app_environment_id = azurerm_container_app_environment.gatling_container_env.id
  account_name                 = var.storage_account_name
  share_name                   = var.storage_share_name
  access_key                   = var.storage_account_primary_access_key
  access_mode                  = "ReadOnly"
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
      target_port      = var.private_package.conf.server.port
      traffic_weight {
        percentage      = 100
        latest_revision = true
      }
    }
  }

  secret {
    name                = local.secret_name
    key_vault_secret_id = var.secret_id
    identity            = "System"
  }

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name    = "control-plane"
      image   = var.image
      cpu     = var.container_cpu
      memory  = var.container_memory
      command = var.command

      env {
        name        = "CONTROL_PLANE_TOKEN"
        secret_name = local.secret_name
      }

      volume_mounts {
        name = local.volume_name
        path = local.path
      }

    }

    volume {
      name         = local.volume_name
      storage_name = local.volume_name
      storage_type = "AzureFile"
    }

  }

  depends_on = [
    azurerm_container_app_environment_storage.gatling_container_env_storage
  ]
}
