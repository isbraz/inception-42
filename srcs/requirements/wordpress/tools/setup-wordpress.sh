#!/bin/bash

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
until mysqladmin ping -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} --silent; do
    echo "MariaDB is unavailable - sleeping"
    sleep 3
done

echo "MariaDB is up - continuing..."

# Change to WordPress directory
cd /var/www/html

# Check if WordPress is already installed
if [ ! -f "wp-config.php" ]; then
    echo "Installing WordPress..."

    # Download WordPress
    wp core download --allow-root

    # Create wp-config.php
    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb:3306 \
        --allow-root

    # Install WordPress
    wp core install \
        --url=${DOMAIN_NAME} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --allow-root

    # Create additional user
    wp user create \
        ${WP_USER} \
        ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASSWORD} \
        --role=author \
        --allow-root

    echo "WordPress installation completed!"
else
    echo "WordPress is already installed."
fi

# Set proper permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Start PHP-FPM in foreground
echo "Starting PHP-FPM..."
exec php-fpm7.4 -F
