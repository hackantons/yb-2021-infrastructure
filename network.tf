resource "aws_vpc" "ybhackathon_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "ybhackathon"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ybhackathon_vpc.id
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.ybhackathon_vpc.id
  cidr_block              = "10.0.0.0/19"
  map_public_ip_on_launch = true
  availability_zone_id    = "euc1-az1"

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.ybhackathon_vpc.id
  cidr_block              = "10.0.32.0/19"
  map_public_ip_on_launch = true
  availability_zone_id    = "euc1-az2"

  tags = {
    Name = "Public Subnet 2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id               = aws_vpc.ybhackathon_vpc.id
  cidr_block           = "10.0.64.0/19"
  availability_zone_id = "euc1-az1"

  tags = {
    Name = "Private Subnet 1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id               = aws_vpc.ybhackathon_vpc.id
  cidr_block           = "10.0.96.0/19"
  availability_zone_id = "euc1-az2"

  tags = {
    Name = "Private Subnet 2"
  }
}

resource "aws_route_table_association" "pub_subnet_1_rt_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.pub_subnet_rt.id
}

resource "aws_route_table_association" "pub_subnet_2_rt_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.pub_subnet_rt.id
}

resource "aws_route_table" "pub_subnet_rt" {
  vpc_id = aws_vpc.ybhackathon_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Subnet Route Table"
  }
}
