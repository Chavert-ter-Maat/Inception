#!/bin/bash

#---------------------------------------------------WordPress Setup---------------------------------------------------#
# Download wp-cli tool for WordPress management
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# Make wp-cli executable
chmod +x wp-cli.phar
# Move wp-cli to the system’s binary directory
mv wp-cli.phar /usr/local/bin/wp

# Change to the WordPress directory
cd /var/www/wordpress
# Set appropriate permissions for WordPress files
chmod -R 755 /var/www/wordpress/
# Assign ownership of the WordPress directory to the web server user
chown -R www-data:www-data /var/www/wordpress
#---------------------------------------------------Check MariaDB Status---------------------------------------------------#
# Verify if the MariaDB service is active
ping_mariadb_container() {
    nc -zv mariadb 3306 > /dev/null # Attempt to connect to MariaDB on port 3306
    return $? # Return the status of the connection attempt
}
start_time=$(date +%s) # Capture the start time of the check
end_time=$((start_time + 20)) # Define a timeout of 20 seconds
while [ $(date +%s) -lt $end_time ]; do # Loop until timeout or successful connection
    ping_mariadb_container # Attempt to ping MariaDB
    if [ $? -eq 0 ]; then # If the connection was successful
        echo "[========MARIADB IS READY========]"
        break # Exit the loop
    else
        echo "[========WAITING FOR MARIADB...========]"
        sleep 1 # Wait 1 second before retrying
    fi
done

if [ $(date +%s) -ge $end_time ]; then # If the timeout has been reached
    echo "[========MARIADB FAILED TO RESPOND========]"
fi
#---------------------------------------------------WordPress Installation---------------------------------------------------#

# Download the latest WordPress core files
wp core download --allow-root
# Generate a wp-config.php file with database credentials
wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DB" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root
# Install WordPress with the specified site details and admin credentials
wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_N" --admin_password="$WP_ADMIN_P" --admin_email="$WP_ADMIN_E" --allow-root
# Create a new user with the provided username, email, password, and role
wp user create "$WP_U_NAME" "$WP_U_EMAIL" --user_pass="$WP_U_PASS" --role="$WP_U_ROLE" --allow-root

#---------------------------------------------------PHP Configuration---------------------------------------------------#

# Update PHP-FPM to listen on port 9000 instead of using a Unix socket
sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf
# Create the necessary directory for PHP-FPM to operate
mkdir -p /run/php
# Start the PHP-FPM service in the foreground to keep the process active
/usr/sbin/php-fpm7.4 -F
