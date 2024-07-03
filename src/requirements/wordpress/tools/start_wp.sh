#!/bin/bash

# Ensure the script exits on any error
set -e

# Maximum number of retries for MySQL connection
max_retries=10
retry_count=0

# Wait for MySQL to be ready (assuming it's running in another container)
until mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent || [ $retry_count -eq $max_retries ]; do
    echo "Waiting for database connection... (Attempt $((retry_count+1)) of $max_retries)"
    sleep 3
    retry_count=$((retry_count+1))
done

if [ $retry_count -eq $max_retries ]; then
    echo "Failed to connect to MySQL after $max_retries attempts."
    exit 1
fi

# Create directory if it doesn't exist
mkdir -p /var/www/html

# Download WordPress if it's not already present
if [ ! -e /var/www/html/index.php ] && [ ! -e /var/www/html/wp-includes/version.php ]; then
    echo "WordPress not found, downloading..."
    wget -qO /tmp/latest.tar.gz https://wordpress.org/latest.tar.gz
    tar -xzf /tmp/latest.tar.gz -C /var/www/html --strip-components=1
    rm /tmp/latest.tar.gz
fi

# Copy wp-config.php
chmod 777 wp-config.php
cp /wp-config.php /var/www/html/

# Update wp-config.php with environment variables
sed -i "s/define( 'DB_NAME', '.*' );/define( 'DB_NAME', '${WORDPRESS_DB_NAME}' );/" /var/www/html/wp-config.php
sed -i "s/define( 'DB_USER', '.*' );/define( 'DB_USER', '${WORDPRESS_DB_USER}' );/" /var/www/html/wp-config.php
sed -i "s/define( 'DB_PASSWORD', '.*' );/define( 'DB_PASSWORD', '${WORDPRESS_DB_PASSWORD}' );/" /var/www/html/wp-config.php
sed -i "s/define( 'DB_HOST', '.*' );/define( 'DB_HOST', '${WORDPRESS_DB_HOST}' );/" /var/www/html/wp-config.php

# Ensure correct ownership of WordPress files
chown -R www-data:www-data /var/www/html

echo "WordPress configured successfully!"

# Start PHP-FPM
echo "Starting PHP-FPM..."
php-fpm7.3 -F