#EC2 Instance module

#Data block for search ami_id for any region
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#EC2 Instance
resource "aws_instance" "instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = element(var.instance_subnet_id, count.index)
  vpc_security_group_ids = var.instance_security_group
  count                  = var.instance_count
  key_name               = var.instance_key_name
  tags = {
    Name = "${var.instance_name}_instance0${count.index + 1}"
    Stand = var.instance_name
  }
}






