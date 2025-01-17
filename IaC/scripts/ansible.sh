#!/bin/bash
set -e  # Завершение скрипта при ошибке

# Переменные для файлов
HOSTS_FILE="/etc/ansible/hosts"
KNOWN_HOSTS_FILE="/home/ubuntu/.ssh/known_hosts"

# Настройка SSH для пользователя ubuntu
mkdir -p /home/ubuntu/.ssh
chown ubuntu:ubuntu /home/ubuntu/.ssh
chmod 700 /home/ubuntu/.ssh

# Сохраняем приватный ключ с правильным форматированием
echo "${ssh_private_key}" | sed 's/\r$//' | tee /home/ubuntu/.ssh/id_rsa > /dev/null

chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa
chmod 600 /home/ubuntu/.ssh/id_rsa

# Устанавливаем Ansible
sudo apt-get update -y
sudo apt-get install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get update -y
sudo apt-get install -y ansible

# Проверка установки Ansible
if ! command -v ansible &> /dev/null
then
    echo "Ansible не установлен. Проверьте логи для устранения ошибки."
    exit 1
fi

# Устанавливаем дополнительные утилиты tree и netstat
sudo apt-get install -y tree net-tools

# Проверка установки tree
if ! command -v tree &> /dev/null
then
    echo "Утилита tree не установлена. Проверьте логи для устранения ошибки."
    exit 1
fi

# Проверка установки netstat
if ! command -v netstat &> /dev/null
then
    echo "Утилита netstat не установлена. Проверьте логи для устранения ошибки."
    exit 1
fi

echo "Ansible, tree и netstat успешно установлены."

# Создание необходимых файлов для Ansible
touch $KNOWN_HOSTS_FILE
chmod 644 $KNOWN_HOSTS_FILE
echo "[myhosts]" > $HOSTS_FILE

# Добавление IP-адресов в hosts и known_hosts
%{ for ip in ips ~}
echo "${ip} ansible_python_interpreter=/usr/bin/python3.12" >> $HOSTS_FILE
ssh-keyscan -H ${ip} >> $KNOWN_HOSTS_FILE
%{ endfor ~}

# Вывод завершения
echo "Настройка завершена. IP-адреса добавлены в файл $HOSTS_FILE, fingerprints в $KNOWN_HOSTS_FILE."
