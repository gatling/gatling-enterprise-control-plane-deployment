output "task-role-arn" {
  value       = aws_iam_role.gatling_role.arn
  description = "Control Plane IAM Role ARN."
}
