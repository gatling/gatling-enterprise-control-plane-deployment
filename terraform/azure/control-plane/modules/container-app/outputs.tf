output "container" {
  value       = azurerm_container_app.gatling_container
  description = "Gatling container running the control plane."
}