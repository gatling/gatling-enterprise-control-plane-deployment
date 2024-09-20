resource "google_secret_manager_secret" "control_plane_secret" {
  secret_id = var.name
  replication {
    auto {
    }
  }
}

resource "google_secret_manager_secret_version" "control_plane_secret_version" {
  secret      = google_secret_manager_secret.control_plane_secret.id
  secret_data = jsonencode({
    "control-plane" = merge(var.extra_content, {
      token       = var.token
      description = var.description
      locations   = [for location in var.locations : location.conf]
      repository  = length(var.private_package) > 0 ? var.private_package.conf : {}
    })
  })
}