#!/bin/bash

mysqld --skip-grant-tables --skip-networking &

sleep 3



# Restarting MariaDB with init file
mysqladmin -u root shutdown

echo "Mariadb initialized and started ..."

mysqld --init-file=/init.sql

echo "Error in starting MariaDB ..."