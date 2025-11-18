locals {
  conf_path       = "/app/conf"
  ssh_path        = "/app/.ssh"
  file_share_path = "/app/.file-share"
  git_path        = "${local.conf_path}/.git-credentials"
  volume_name     = "control-plane-conf"
  ssh_volume_name = "ssh-key-vol"
  file_share_name = "file-share-vol"
  git = {
    ssh_enabled   = length(var.git.ssh.storage-account-name) > 0
    creds_enabled = length(var.git.credentials.username) > 0 && length(var.git.credentials.token-secret-id) > 0
  }
  secrets = concat(
    [
      {
        name        = "CONTROL_PLANE_TOKEN"
        secret-name = "control-plane-token"
        secret-id   = var.token-secret-id
      }
  ], var.container-app.secrets)
  environment = concat(
    local.git.creds_enabled ?
    [
      {
        name  = "GIT_CREDENTIALS"
        value = local.git_path
      }
    ] : [],
  var.container-app.environment)
  config_content = <<-EOF
    control-plane {
      token = $${?CONTROL_PLANE_TOKEN}
      description = "${var.description}"
      enterprise-cloud = ${jsonencode(var.enterprise-cloud)}
      locations = [%{for location in var.locations} ${jsonencode(location.conf)}, %{endfor}]
      server = ${jsonencode(var.server)}
      %{if length(var.private-package) > 0}repository = ${jsonencode(var.private-package.conf)}%{endif}
      %{for key, value in var.extra-content}${key} = "${value}"%{endfor}
    }
  EOF
  mountPoints = concat(
    [
      {
        sourceVolume : local.volume_name
        containerPath : local.conf_path
      }
    ],
    local.git.ssh_enabled ? [
      {
        sourceVolume : local.ssh_volume_name
        containerPath : local.ssh_path
      }
    ] : [],
    [
      for cache_path in var.git.cache.paths : {
        sourceVolume  = local.volume_name
        containerPath = cache_path
      }
  ])
  init_commands = compact([
    "echo \"$CONFIG_CONTENT\" > ${local.conf_path}/control-plane.conf && chown -R 1001 ${local.conf_path} && chmod 400 ${local.conf_path}/control-plane.conf",
    local.git.ssh_enabled ? "echo 'Host ${var.git.host}\n IdentityFile ${local.ssh_path}/${var.git.ssh.file-name}\n StrictHostKeyChecking no' >> ${local.ssh_path}/config && cp ${local.file_share_path}/${var.git.ssh.file-name} ${local.ssh_path}/${var.git.ssh.file-name} && chown -R 1001 ${local.ssh_path} && chmod 400 ${local.ssh_path}/config ${local.ssh_path}/${var.git.ssh.file-name}" : "",
    local.git.creds_enabled ? "echo \"https://$GIT_USERNAME:$GIT_TOKEN@${var.git.host}\" > ${local.git_path} && chown -R 1001 ${local.conf_path} && chmod 400 ${local.git_path}" : ""
  ])
  init = {
    command = [
      "/bin/sh",
      "-c",
      join(" && ", local.init_commands)
    ]
    secrets = local.git.creds_enabled ? [
      {
        name        = "GIT_TOKEN"
        secret-name = "git-token"
        secret-id   = var.git.credentials.token-secret-id
      }
    ] : []
    environment = concat(
      [
        {
          name  = "CONFIG_CONTENT"
          value = local.config_content
        }
      ],
      local.git.creds_enabled ? [
        {
          name  = "GIT_USERNAME"
          value = var.git.credentials.username
        },
        {
          name  = "GIT_CREDENTIALS"
          value = local.git_path
        }
      ] : []
    )
    mountPoints = concat(
      [
        {
          sourceVolume : local.volume_name
          containerPath : local.conf_path
        }
      ],
      local.git.ssh_enabled ? [
        {
          sourceVolume : local.ssh_volume_name
          containerPath : local.ssh_path
        },
        {
          sourceVolume : local.file_share_name
          containerPath : local.file_share_path
        }
    ] : [])
  }
}

resource "azurerm_container_app_environment" "gatling_container_env" {
  name                = "${var.name}-env"
  resource_group_name = var.resource-group-name
  location            = var.region
}

resource "azurerm_container_app_environment_storage" "gatling_container_env_storage" {
  count                        = local.git.ssh_enabled ? 1 : 0
  name                         = local.file_share_name
  container_app_environment_id = azurerm_container_app_environment.gatling_container_env.id
  account_name                 = var.git.ssh.storage-account-name
  share_name                   = var.git.ssh.file-share-name
  access_key                   = var.git.ssh.account-primary-access-key
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

  ingress {
    external_enabled = var.container-app.expose-externally
    target_port      = var.server.port
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  dynamic "secret" {
    for_each = concat(local.init.secrets, local.secrets)
    content {
      name                = secret.value.secret-name
      key_vault_secret_id = secret.value.secret-id
      identity            = "System"
    }
  }

  template {
    min_replicas = 1
    max_replicas = 1

    init_container {
      name    = "conf-loader-init-container"
      image   = var.container-app.init.image
      cpu     = "0.25"
      memory  = "0.5Gi"
      command = local.init.command

      dynamic "env" {
        for_each = concat(local.init.environment, local.init.secrets)
        content {
          name        = env.value.name
          value       = lookup(env.value, "value", null)
          secret_name = lookup(env.value, "secret-name", null)
        }
      }

      dynamic "volume_mounts" {
        for_each = local.init.mountPoints
        content {
          name = volume_mounts.value.sourceVolume
          path = volume_mounts.value.containerPath
        }
      }
    }

    container {
      name    = "control-plane"
      image   = var.container-app.image
      cpu     = var.container-app.cpu
      memory  = var.container-app.memory
      command = var.container-app.command

      dynamic "env" {
        for_each = concat(local.environment, local.secrets)
        content {
          name        = env.value.name
          value       = lookup(env.value, "value", null)
          secret_name = lookup(env.value, "secret-name", null)
        }
      }

      dynamic "volume_mounts" {
        for_each = local.mountPoints
        content {
          name = volume_mounts.value.sourceVolume
          path = volume_mounts.value.containerPath
        }
      }
    }

    volume {
      name         = local.volume_name
      storage_type = "EmptyDir"
    }

    dynamic "volume" {
      for_each = local.git.ssh_enabled ? [1] : []
      content {
        name         = local.ssh_volume_name
        storage_type = "EmptyDir"
      }
    }

    dynamic "volume" {
      for_each = local.git.ssh_enabled ? [1] : []
      content {
        name         = local.file_share_name
        storage_name = local.file_share_name
        storage_type = "AzureFile"
      }
    }
  }

  depends_on = [
    azurerm_container_app_environment_storage.gatling_container_env_storage
  ]
}
