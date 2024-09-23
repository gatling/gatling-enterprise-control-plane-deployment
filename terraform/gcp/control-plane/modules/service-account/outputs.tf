output "email" {
  value       = google_service_account.service_account.email
  description = "Storage share name used to store the configuration."
}