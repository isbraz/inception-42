#!/bin/bash

# Start MySQL service temporarily for initial setup
service mariadb start

# Wait for MySQL to be ready
until mysqladmin ping --silent; do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
done

# Check if database already exists
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Initializing database..."

    # Create database
    mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    echo "Database initialized successfully!"
else
    echo "Database already exists, skipping initialization."
fi

# Stop temporary MySQL service
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# Start MySQL in foreground
exec mysqld --user=mysql --console
