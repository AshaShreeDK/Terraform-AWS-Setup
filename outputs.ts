output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "ec2_instances" {
  description = "List of private IPs of EC2 instances"
  value       = module.ec2.instances
}

output "alb_dns" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns
}

output "route53_zone_id" {
  description = "Route 53 Private Hosted Zone ID"
  value       = module.route53.private_dns
}
