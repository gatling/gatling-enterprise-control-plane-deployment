output "pp_alb_target_group_arn" {
  value       = length(aws_lb_target_group.gatling_tg) > 0 ? aws_lb_target_group.gatling_tg[0].arn   : ""
  description = "Target Group ARN of the Application Load Balancer."
}

output "pp_alb_dns_name" {
  value       = length(aws_lb.gatling_alb) > 0 ? aws_lb.gatling_alb[0].dns_name : ""
  description = "DNS Name of the Application Load Balancer."
}

output "pp_alb_listener_id" {
  value       = length(aws_lb_listener.gatling_listener) > 0 ? aws_lb_listener.gatling_listener[0].id  : ""
  description = "Listener of the Application Load Balancer."
}