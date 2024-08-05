output "ecs_tasks_iam_role_arn" {
  value       = aws_iam_role.gatling_role.arn
  description = "Control Plane IAM Role ARN."
}