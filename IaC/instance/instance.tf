#EC2 Instance module

#Data block for search ami_id for any region


#EC2 Instance
data "aws_secretsmanager_secret" "ssh_private_key" {
  name = "my_github-ssh-key_2"  # Имя секрета в Secrets Manager
}

data "aws_secretsmanager_secret_version" "ssh_key_version" {
  secret_id = data.aws_secretsmanager_secret.ssh_private_key.id
}


resource "aws_instance" "instance" {
  ami                    = var.aws_ami
  instance_type          = var.instance_type
  subnet_id              = element(var.instance_subnet_id, count.index)
  vpc_security_group_ids = var.instance_security_group
  count                  = var.instance_count
  key_name               = var.instance_key_name
  # Загружаем скрипт из файла, имя которого задано переменной
  #user_data = file(var.user_data_file)
  user_data = templatefile(var.user_data_file, {
    ssh_private_key = data.aws_secretsmanager_secret_version.ssh_key_version.secret_string
  })



  tags = {
    Name = "${var.instance_name}_instance_${count.index + 1}"
    Stand = var.instance_name
  }
}






