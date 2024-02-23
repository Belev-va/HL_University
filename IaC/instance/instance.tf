#EC2 Instance module

#Data block for search ami_id for any region


#EC2 Instance
resource "aws_instance" "instance" {
  ami                    = var.aws_ami
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






