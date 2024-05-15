output "target_group_arn" {
  value       = length(aws_lb_target_group.gatling_tg) > 0 ? aws_lb_target_group.gatling_tg[0].arn   : ""
  description = "Target Group ARN of the Application Load Balancer."
}

output "dns_name" {
  value       = length(aws_lb.gatling_alb) > 0 ? aws_lb.gatling_alb[0].dns_name : ""
  description = "DNS Name of the Application Load Balancer."
}