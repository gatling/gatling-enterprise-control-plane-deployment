locals {
  path        = "/app/conf"
  volume-name = "control-plane-conf"
  secret-name = "token-secret-id"
  environment = concat(
    [
      {
        name        = "CONTROL_PLANE_TOKEN"
        secret-name = local.secret-name
      }
    ],
    var.container.environment
  )
}

resource "azurerm_container_app_environment" "gatling_container_env" {
  name                = "${var.name}-env"
  resource_group_name = var.resource-group-name
  location            = var.region
}

resource "azurerm_container_app_environment_storage" "gatling_container_env_storage" {
  name                         = local.volume-name
  container_app_environment_id = azurerm_container_app_environment.gatling_container_env.id
  account_name                 = var.storage.account-name
  share_name                   = var.storage.share-name
  access_key                   = var.storage.account-primary-access-key
  access_mode                  = "ReadOnly"
}

resource "azurerm_container_app" "gatling_container" {
  name                         = var.name
  resource_group_name          = var.resource-group-name
  container_app_environment_id = azurerm_container_app_environment.gatling_container_env.id
  revision_mode                = "Single"

  identity {
    type = "SystemAssigned"
  }

  dynamic "ingress" {
    for_each = length(var.private-package) > 0 ? [1] : []
    content {
      external_enabled = true
      target_port      = var.private-package.conf.server.port
      traffic_weight {
        percentage      = 100
        latest_revision = true
      }
    }
  }

  secret {
    name                = local.secret-name
    key_vault_secret_id = var.secret-id
    identity            = "System"
  }

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name    = "control-plane"
      image   = var.container.image
      cpu     = var.container.cpu
      memory  = var.container.memory
      command = var.container.command

      dynamic "env" {
        for_each = local.environment
        content {
          name        = env.value.name
          value       = lookup(env.value, "value", null)
          secret_name = lookup(env.value, "secret-name", null)
        }
      }

      volume_mounts {
        name = local.volume-name
        path = local.path
      }
    }

    volume {
      name         = local.volume-name
      storage_name = local.volume-name
      storage_type = "AzureFile"
    }
  }

  depends_on = [
    azurerm_container_app_environment_storage.gatling_container_env_storage
  ]
}
