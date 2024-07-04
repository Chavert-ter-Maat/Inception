#!bin/bash

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]
then
	service mariadb start;
	sleep 3
    echo "Creating database: ${MYSQL_DATABASE}"

    mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -e "CREATE USER IF NOT EXISTS  \`${MYSQL_USER}\`@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -e "FLUSH PRIVILEGES;"
	service mariadb stop;
fi

echo "exec(mysqld)"
exec mysqld