#!/bin/bash

# Start the MariaDB service
service mariadb start 

# Wait for 5 seconds to ensure MariaDB has started before proceeding
sleep 5 

# Create a new database if it doesn't already exist, using the value of MYSQL_DB environment variable
mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;"

# Create a new user if it doesn't already exist, using MYSQL_USER and MYSQL_PASSWORD environment variables
mariadb -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# Grant all privileges on the database to the newly created user
mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO \`${MYSQL_USER}\`@'%';"

# Reload the privilege tables to ensure that all changes take effect
mariadb -e "FLUSH PRIVILEGES;"

# Shut down MariaDB in preparation for restarting it with the updated configuration
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

# Restart MariaDB using mysqld_safe in the background, binding it to all interfaces and specifying the data directory
mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'
