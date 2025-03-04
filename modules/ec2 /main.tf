resource "aws_instance" "servers" {
  count         = 3
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = element(var.subnets, count.index)

  user_data = <<-EOF
              #!/bin/bash
              echo "I am server${count.index + 1}" > /var/www/html/index.html
              sudo yum install -y httpd
              sudo systemctl enable httpd
              sudo systemctl start httpd
              EOF

  tags = { Name = "server${count.index + 1}" }
}
