resource "aws_vpc" "dk-vpc" {
  cidr_block = var.vpc_cidr
  tags = { Name = "dk-vpc" }
}

resource "aws_subnet" "dk-public-subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.dk-vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = { Name = "dk-public-subnet-${count.index}" }
}

resource "aws_subnet" "dk-private-subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.dk-vpc.id
  cidr_block              = "10.0.${count.index + 10}.0/24"
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
  tags = { Name = "dk-private-subnet-${count.index}" }
}

resource "aws_internet_gateway" "dk-igw" {
  vpc_id = aws_vpc.dk-vpc.id
  tags = { Name = "dk-igw" }
}
