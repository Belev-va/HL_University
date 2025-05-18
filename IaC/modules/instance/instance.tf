#EC2 Instance module

data "aws_secretsmanager_secret" "ssh_private_key" {
  name = "my_github-ssh-key"  # Имя секрета в Secrets Manager
}

data "aws_secretsmanager_secret_version" "ssh_key_version" {
  secret_id = data.aws_secretsmanager_secret.ssh_private_key.id
}

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [lookup(local.ami_name_patterns, var.os_name, "ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*")]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [lookup(local.ami_owners, var.os_name, "099720109477")]
}




resource "aws_instance" "instance" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance_type
  subnet_id              = element(var.instance_subnet_id, count.index)
  vpc_security_group_ids = var.instance_security_group
  count                  = var.instance_count
  key_name               = var.instance_key_name

  user_data = templatefile(var.user_data_file, {
    ssh_private_key = data.aws_secretsmanager_secret_version.ssh_key_version.secret_string
    ips             = var.public_instance_ips
  })

  # 👇 Добавляем блок настройки диска
  root_block_device {
    volume_size = var.instance_volume_size          # Размер в GiB
    volume_type = "gp3"        # Тип диска (можно gp2, io1, io2, sc1 и т.д.)
    delete_on_termination = true
  }

  tags = {
    Name  = "${var.instance_name}_instance_${count.index + 1}"
    Stand = var.instance_name
  }
}






