output "ecs_tasks_iam_role_name" {
  value       = module.iam.ecs_tasks_iam_role_name
  description = "Control Plane IAM Role name."
}
