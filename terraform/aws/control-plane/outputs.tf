output "ecs_tasks_iam_role_name" {
  value       = module.iam.ecs_tasks_iam_role_name
  description = "Control Plane IAM Role name."
}

output "alb_dns_name" {
  value       = module.alb.dns_name
  description = "DNS Name of the Application Load Balancer."
}
