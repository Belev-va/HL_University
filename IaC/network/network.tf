# Add network
resource "aws_vpc" "dev_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name  = "${var.name}_vpc"
    Stage = var.name
  }
}

# Add AWS public subnet
resource "aws_subnet" "dev_vpc_public_subnet" {
  cidr_block              = var.cidr_public_subnet
  vpc_id                  = aws_vpc.dev_vpc.id
  availability_zone       = var.availability_zone_public
  map_public_ip_on_launch = "true"
  tags = {
    Name  = "${var.name}_public_subnet"
    Stage = var.name
  }
}

# Add AWS private subnet
resource "aws_subnet" "dev_vpc_private_subnet" {
  cidr_block        = var.cidr_private_subnet
  vpc_id            = aws_vpc.dev_vpc.id
  availability_zone = var.availability_zone_private
  tags = {
    Name  = "${var.name}_private_subnet"
    Stage = var.name
  }
}

# Add AWS internet gateway
resource "aws_internet_gateway" "dev_igw" {
  vpc_id  = aws_vpc.dev_vpc.id
  tags = {
    Name  = "${var.name}_ig"
    Stage = var.name
  }
}

# Add Elastic IP addresse
resource "aws_eip" "dev_eip" {
  domain   = "vpc"
  depends_on = [aws_internet_gateway.dev_igw]
  tags = {
    Name  = "${var.name}_eip"
    Stage = var.name
  }
}

# Add NAT
resource "aws_nat_gateway" "dev_nat" {
  allocation_id = aws_eip.dev_eip.id
  subnet_id     = aws_subnet.dev_vpc_public_subnet.id
  depends_on    = [aws_internet_gateway.dev_igw]
  tags = {
    Name  = "${var.name}_nat"
    Stage = var.name
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "dev_rt_private" {
  vpc_id  = aws_vpc.dev_vpc.id
  tags = {
    Name  = "${var.name}_rt_private"
    Stage = var.name
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "dev_rt_public" {
  vpc_id  = aws_vpc.dev_vpc.id
  tags = {
    Name  = "${var.name}_rt_public"
    Stage = var.name
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id            = aws_route_table.dev_rt_public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.dev_igw.id
}
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.dev_rt_private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.dev_nat.id
}
/* Route table associations */
resource "aws_route_table_association" "dev_rt_association_public" {
  subnet_id      = aws_subnet.dev_vpc_public_subnet.id
  route_table_id = aws_route_table.dev_rt_public.id
}
resource "aws_route_table_association" "dev_rt_association_private" {
  subnet_id      = aws_subnet.dev_vpc_private_subnet.id
  route_table_id = aws_route_table.dev_rt_private.id
}
# Default security group
resource "aws_security_group" "dev_sg" {
  name        = "${var.name}-default-sg"
  description = "Allow"
  vpc_id      = aws_vpc.dev_vpc.id
  depends_on  = [aws_vpc.dev_vpc]

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.dev_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.dev_vpc.cidr_block]
  }
  tags = {
    Name  = "${var.name}_sg"
    Stage = "${var.name}"

  }
}