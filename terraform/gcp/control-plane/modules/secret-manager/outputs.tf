output "secret_name" {
  value = google_secret_manager_secret.control_plane_secret.secret_id
}