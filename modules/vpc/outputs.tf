output "vpc_id" { value = aws_vpc.dk-vpc.id }
output "public_subnets" { value = aws_subnet.dk-public-subnet[*].id }
output "private_subnets" { value = aws_subnet.dk-private-subnet[*].id }
