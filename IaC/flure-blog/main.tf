data "aws_availability_zones" "available" {}

resource "aws_lightsail_key_pair" "wp_key_pairs" {
  for_each  = toset(var.ssh_key_paths)
  name      = "${var.instance_name}-key-${basename(each.value)}"
  public_key = file(each.value)
  tags      = var.tags
}

resource "aws_lightsail_instance" "wp_instance" {
  name              = var.instance_name
  blueprint_id      = var.app
  bundle_id         = var.instance_type
  availability_zone = data.aws_availability_zones.available.names[0]
  key_pair_name    = values(aws_lightsail_key_pair.wp_key_pairs)[0].name
  add_on {
    type          = "AutoSnapshot"
    snapshot_time = "06:00"
    status        = "Enabled"
  }
  tags = var.tags

  user_data = <<-EOF
  #!/bin/bash
  set -e  # Останавливаем выполнение при ошибке
  exec > /tmp/user_data.log 2>&1  # Логируем в файл

  echo "=== Добавляем SSH-ключи ==="
  ${join("\n", [
    for key_path in var.ssh_key_paths :
cd    "echo '${file(key_path)}' >> /home/bitnami/.ssh/authorized_keys"
  ])}
  chmod 600 /home/bitnami/.ssh/authorized_keys
  chown bitnami:bitnami /home/bitnami/.ssh/authorized_keys

  echo "=== Отключаем SSL-конфиг Bitnami ==="
  sudo mv /opt/bitnami/apache2/conf/bitnami/bitnami-ssl.conf /opt/bitnami/apache2/conf/bitnami/bitnami-ssl.conf.disabled || true

  echo "=== Убираем Include из bitnami.conf ==="
  sudo sed -i 's|Include "/opt/bitnami/apache2/conf/bitnami/bitnami-ssl.conf"|# &|' /opt/bitnami/apache2/conf/bitnami.conf

  echo "=== Обновляем wp-config.php ==="
  sudo sed -i "/define( 'WP_HOME',/d" /opt/bitnami/wordpress/wp-config.php
  sudo sed -i "/define( 'WP_SITEURL',/d" /opt/bitnami/wordpress/wp-config.php
  sudo sed -i "/define( 'WP_AUTO_UPDATE_CORE', 'minor' );/i define( 'WP_HOME', 'https://www.flure.com/testing-blog' );\ndefine( 'WP_SITEURL', 'https://www.flure.com/testing-blog' );" /opt/bitnami/wordpress/wp-config.php

  echo "=== Обновляем .htaccess ==="
  echo '
  <IfModule mod_rewrite.c>
  RewriteEngine On
  RewriteBase /
  RewriteRule ^index\\.php$ - [L]
  RewriteCond %%{REQUEST_FILENAME} !-f
  RewriteCond %%{REQUEST_FILENAME} !-d
  RewriteRule . /index.php [L]
  </IfModule>
  ' | sudo tee /opt/bitnami/wordpress/.htaccess

  echo "=== Обновляем wordpress-vhost.conf ==="
  echo '
  <VirtualHost *:80>
      ServerName flure.com
      ServerAlias www.flure.com
      DocumentRoot "/opt/bitnami/wordpress"

      <Directory "/opt/bitnami/wordpress">
          AllowOverride All
          Require all granted
      </Directory>

      Alias /testing-blog/ "/opt/bitnami/wordpress/"

      <Directory "/opt/bitnami/wordpress">
          AllowOverride All
          Require all granted
      </Directory>

      ErrorLog "logs/wordpress-error_log"
      CustomLog "logs/wordpress-access_log" common
  </VirtualHost>
  ' | sudo tee /opt/bitnami/apache2/conf/vhosts/wordpress-vhost.conf

  echo "=== Перезапускаем Apache ==="
  sudo /opt/bitnami/ctlscript.sh restart apache
EOF

}

resource "aws_lightsail_static_ip" "wp_static_ip" {
  name = "${var.instance_name}-static-ip"
}

resource "aws_lightsail_static_ip_attachment" "wp_ip_attach" {
  static_ip_name = aws_lightsail_static_ip.wp_static_ip.name
  instance_name  = aws_lightsail_instance.wp_instance.name
}
