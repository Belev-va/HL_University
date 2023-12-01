// EC2 Instance Resource for Module
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

resource "aws_instance" "instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.instance_subnet_id
  #vpc_security_group_ids = var.instance_security_group
  count = var.instance_count
  tags = {
    Name = "${var.instance_name}-${count.index + 1}"
  }

}

