# Create ALB
resource "aws_lb" "dk-alb" {
  name               = "dk-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = var.public_subnets

  enable_deletion_protection = false

  tags = {
    Name = "dk-alb"
  }
}

# Create ALB Target Groups
resource "aws_lb_target_group" "server1" {
  name     = "tg-server1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group" "server2" {
  name     = "tg-server2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
  }
}

resource "aws_lb_target_group" "interview" {
  name     = "tg-interview"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
  }
}

# Attach EC2 instances to respective target groups
resource "aws_lb_target_group_attachment" "server1" {
  target_group_arn = aws_lb_target_group.server1.arn
  target_id        = var.instance_ids[0]
}

resource "aws_lb_target_group_attachment" "server2" {
  target_group_arn = aws_lb_target_group.server2.arn
  target_id        = var.instance_ids[1]
}

resource "aws_lb_target_group_attachment" "interview" {
  target_group_arn = aws_lb_target_group.interview.arn
  target_id        = var.instance_ids[2]
}

# ALB Listener for Context-Based Routing
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.dk-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Invalid Path"
      status_code  = "404"
    }
  }
}
resource "aws_lb_listener_rule" "server1" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  condition {
    path_pattern {
      values = ["/server1"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server1.arn
  }
}

resource "aws_lb_listener_rule" "server2" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20

  condition {
    path_pattern {
      values = ["/server2"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server2.arn
  }
}

resource "aws_lb_listener_rule" "interview" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 30

  condition {
    path_pattern {
      values = ["/interview"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.interview.arn
  }
}
resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg-"
  description = "Allow HTTP and HTTPS traffic for ALB"
  vpc_id      = var.vpc_id  # Ensure your module receives vpc_id as input

  # Allow inbound HTTP (Port 80) from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow inbound HTTPS (Port 443) from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}
