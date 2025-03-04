output "alb_dns" {
  description = "DNS Name of the ALB"
  value       = aws_lb.dk-alb.dns_name
}
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}
