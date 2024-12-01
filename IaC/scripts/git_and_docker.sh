#!/bin/bash
  set -e  # Завершение скрипта при ошибке

  # Настройка SSH для пользователя ubuntu
  mkdir -p /home/ubuntu/.ssh
  chown ubuntu:ubuntu /home/ubuntu/.ssh
  chmod 700 /home/ubuntu/.ssh

  # Сохраняем приватный ключ с правильным форматированием - sed will delete ^M for cat -A id_rsa
  echo "${ssh_private_key}" | sed 's/\r$//' | tee /home/ubuntu/.ssh/id_rsa > /dev/null

  chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
  chmod 600 /home/ubuntu/.ssh/id_rsa

  # Устанавливаем Git и Docker
  sudo apt-get update -y
  sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common git

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
  sudo apt-get update -y
  sudo apt-get install -y docker-ce docker-compose
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo usermod -aG docker ubuntu


  # Настройка Git
  sudo -u ubuntu git config --global user.name "Belev-va"
  sudo -u ubuntu git config --global user.email "belev.job@gmail.com"

  # Настройка SSH для GitHub
  echo -e "Host github.com\n\tStrictHostKeyChecking no\n" > /home/ubuntu/.ssh/config
  chown ubuntu:ubuntu /home/ubuntu/.ssh/config
  chmod 644 /home/ubuntu/.ssh/config

  # Клонирование репозитория
  cd /home/ubuntu
  sudo -u ubuntu ssh-agent bash -c "ssh-add /home/ubuntu/.ssh/id_rsa && git clone git@github.com:Belev-va/twodomainsonnginx.git"

  # Деплой приложения
  cd twodomainsonnginx
  docker compose up -d