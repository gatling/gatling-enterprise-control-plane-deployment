output "ControlPlaneUrl" {
  value       = module.control-plane.alb_dns_name != "" ? "http://${module.control-plane.alb_dns_name}" : null
  description = "Your Control Plane URL:"
}