# Data for search availability_zones in any region
data "aws_availability_zones" "available" {}

# Add network
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name  = "${var.name}_vpc"
    Stand = var.name
  }
}

# Add internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id  = aws_vpc.vpc.id
  tags = {
    Name  = "${var.name}_igw"
    Stand = var.name
  }
}

# Add public subnet withs routing
resource "aws_subnet" "vpc_public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.cidr_public_subnet)
  cidr_block              = element(var.cidr_public_subnet, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = "true"
  tags = {
    Name  = "${var.name}_public_subnet_${count.index + 1}"
    Stand = var.name
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id  = aws_vpc.vpc.id
  tags = {
    Name  = "${var.name}_rt_public"
    Stand = var.name
  }
}

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.rt_public.id
  destination_cidr_block    = var.destination_cidr_block
  gateway_id                = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "rt_association_public" {
  count          = length(aws_subnet.vpc_public_subnet[*].id)
  subnet_id      = element(aws_subnet.vpc_public_subnet[*].id, count.index)
  route_table_id = aws_route_table.rt_public.id
}

# Add AWS private subnet withs routing
resource "aws_subnet" "vpc_private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.cidr_private_subnet)
  cidr_block              = element(var.cidr_private_subnet, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name  = "${var.name}_private_subnet_${count.index + 1}"
    Stand = var.name
  }
}

# Add Elastic IP addresses
resource "aws_eip" "eip" {
  count   = length(var.cidr_private_subnet)
  domain      = "vpc"
  depends_on  = [aws_internet_gateway.igw]
  tags = {
    Name   = "${var.name}_eip_${count.index + 1}"
    Stand  = var.name
  }
}

# Add NAT
resource "aws_nat_gateway" "nat" {
  count         = length(var.cidr_private_subnet)
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = element(aws_subnet.vpc_public_subnet[*].id, count.index)
  tags = {
    Name  = "${var.name}_nat_${count.index + 1}"
    Stand = var.name
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "rt_private" {
  count   = length(var.cidr_private_subnet)
  vpc_id  = aws_vpc.vpc.id
  route {
    cidr_block = var.destination_cidr_block
    gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = {
    Name  = "${var.name}_rt_private_${count.index + 1}"
    Stand = var.name
  }
}

resource "aws_route_table_association" "rt_association_private" {
  count          = length(aws_subnet.vpc_private_subnet[*].id)
  subnet_id      = element(aws_subnet.vpc_private_subnet[*].id, count.index)
  route_table_id = aws_route_table.rt_private[count.index].id
}

