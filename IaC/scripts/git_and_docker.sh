#!/bin/bash
set -e  # Завершение скрипта при ошибке

# Определяем пользователя (на Debian он debian, а на Ubuntu ubuntu)
USERNAME="admin"
if id "ubuntu" &>/dev/null; then
  USERNAME="ubuntu"
fi

# Настройка SSH
mkdir -p /home/$USERNAME/.ssh
chown $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh

# Сохраняем приватный ключ
echo "${ssh_private_key}" | sed 's/\r$//' | tee /home/$USERNAME/.ssh/id_rsa > /dev/null
chown $USERNAME:$USERNAME /home/$USERNAME/.ssh/id_rsa
chmod 600 /home/$USERNAME/.ssh/id_rsa

# Устанавливаем необходимые пакеты
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl git software-properties-common

# Устанавливаем Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian bookworm stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USERNAME

# Настройка Git
sudo -u $USERNAME git config --global user.name "Belev-va"
sudo -u $USERNAME git config --global user.email "belev.job@gmail.com"

# Настройка SSH для GitHub
echo -e "Host github.com\n\tStrictHostKeyChecking no\n" > /home/$USERNAME/.ssh/config
chown $USERNAME:$USERNAME /home/$USERNAME/.ssh/config
chmod 644 /home/$USERNAME/.ssh/config
