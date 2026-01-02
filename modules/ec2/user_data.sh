#!/bin/bash
set -e

yum update -y
amazon-linux-extras enable php8.0 -y
yum install -y httpd php php-mysqlnd wget tar

systemctl start httpd
systemctl enable httpd

cd /var/www/html

# Remove Apache test page
rm -f index.html

# Download and extract WordPress into root
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest.tar.gz

# Set permissions
chown -R apache:apache /var/www/html

# Configure WordPress
cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/${db_name}/" wp-config.php
sed -i "s/username_here/${db_username}/" wp-config.php
sed -i "s/password_here/${db_password}/" wp-config.php
sed -i "s/localhost/${db_host}/" wp-config.php

# ALB + HTTPS support
cat <<EOF >> wp-config.php

define('WP_HOME', 'https://${domain_name}');
define('WP_SITEURL', 'https://${domain_name}');

if (
    isset(\$_SERVER['HTTP_X_FORWARDED_PROTO']) &&
    \$_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https'
) {
    \$_SERVER['HTTPS'] = 'on';
}
EOF

systemctl restart httpd
