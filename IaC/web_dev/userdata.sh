#!/bin/bash
# Add ssh-keys
for key_path in ${join(" ", var.ssh_key_paths)}; do
  echo "$(cat $key_path)" >> /home/bitnami/.ssh/authorized_keys
done

chmod 600 /home/bitnami/.ssh/authorized_keys
chown bitnami:bitnami /home/bitnami/.ssh/authorized_keys

# Disable bitnami-ssl.conf
sudo mv /opt/bitnami/apache2/conf/bitnami/bitnami-ssl.conf /opt/bitnami/apache2/conf/bitnami/bitnami-ssl.conf.disabled

# Hide Include in bitnami.conf
sudo sed -i 's|Include "/opt/bitnami/apache/conf/bitnami/bitnami-ssl.conf"|# &|' /opt/bitnami/apache2/conf/bitnami/bitnami.conf

# Update WP_HOME and WP_SITEURL in wp-config.php
sudo sed -i "/define( 'WP_HOME',/d" /opt/bitnami/wordpress/wp-config.php
sudo sed -i "/define( 'WP_SITEURL',/d" /opt/bitnami/wordpress/wp-config.php

sudo sed -i "/define( 'WP_AUTO_UPDATE_CORE', 'minor' );/i define( 'WP_HOME', 'https://www.flure.com/testing-blog' );\ndefine( 'WP_SITEURL', 'https://www.flure.com/testing-blog' );" /opt/bitnami/wordpress/wp-config.php

# Update .htaccess
cat <<EOT | sudo tee /opt/bitnami/wordpress/.htaccess
# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
EOT

# Update wordpress-vhost.conf
cat <<EOT | sudo tee /opt/bitnami/apache2/conf/vhosts/wordpress-vhost.conf
<VirtualHost *:80>
    ServerName flure.com
    ServerAlias www.flure.com
    DocumentRoot "/opt/bitnami/wordpress"

    <Directory "/opt/bitnami/wordpress">
        AllowOverride All
        Require all granted
    </Directory>

    Alias /testing-blog/ "/opt/bitnami/wordpress/
    <Directory "/opt/bitnami/wordpress">
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog "logs/wordpress-error_log"
    CustomLog "logs/wordpress-access_log" common
</VirtualHost>
EOT

# Restart Apache
sudo /opt/bitnami/ctlscript.sh restart apache
