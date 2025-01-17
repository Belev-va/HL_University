# Default security group
resource "aws_security_group" "public_sg" {
  count       = var.create_public_sg ? 1 : 0
  name        = "${var.name}_public_sg"
  description = var.public_description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_public_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.public_cidr
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.public_cidr
  }
  tags = {
    Name  = "${var.name}_sg"
    Stand = var.name

  }
}

resource "aws_security_group" "private_sg" {
  count       = var.create_private_sg ? 1 : 0
  name        = "${var.name}_private_sg"
  description = var.private_description
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.private_cidr
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.public_cidr
  }
  tags = {
    Name  = "${var.name}_sg"
    Stand = var.name

  }
}
