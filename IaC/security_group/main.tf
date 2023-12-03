# Default security group
resource "aws_security_group" "public_sg" {
  name        = "${var.name}_public_sg"
  description = var.public_description
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.public_cidr
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.public_cidr
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.public_cidr
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

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key =  file("terraform_ec2_key.pub")
}