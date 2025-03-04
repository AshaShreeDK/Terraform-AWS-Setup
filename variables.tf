variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  default     = "ami-0ef0a3b4303b17ec5"
}

variable "alb_sg" {
  description = "Security group for ALB"
  type        = string
}

variable "private_zone_name" {
  description = "Private DNS zone name"
  default     = "dlrasha.cloud"
}
