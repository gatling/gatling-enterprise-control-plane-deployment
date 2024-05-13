output "ControlPlaneURL" {
  description = "Your control plane URL"
  value       = var.pp_flag ? "http://${module.alb.pp_alb_dns_name}" : null
}