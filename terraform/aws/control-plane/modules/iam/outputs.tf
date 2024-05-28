output "ecs_tasks_iam_role_name" {
  value       = aws_iam_role.gatling_role.name
  description = "Control Plane IAM Role name."
}

output "ecs_tasks_iam_role_arn" {
  value       = aws_iam_role.gatling_role.arn
  description = "Control Plane IAM Role ARN."
}