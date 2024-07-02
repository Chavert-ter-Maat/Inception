FROM debian:buster

# Update package lists and install necessary packages
RUN apt-get update \
    && apt-get install -y \
        mariadb-server \  
        mariadb-client \ 
        vim \     
    && rm -rf /var/lib/apt/lists/*  

# Allow MariaDB daemon to run
# Purge and re-create /var/lib/mysql with appropriate ownership
# Ensure /var/run/mysqld (used for socket and lock files) is writable
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

# Expose MariaDB port
EXPOSE 3306

# Copy configuration and initialization scripts into the container
COPY ./tools/start.sh /usr/local/bin/   
COPY ./configs/wordpress.sql /usr/local/bin/  

# Set executable permissions for the scripts
RUN chmod +x /usr/local/bin/start.sh \
    && chmod +x /usr/local/bin/wordpress.sql

# Set the entrypoint to start.sh script
ENTRYPOINT ["/usr/local/bin/start.sh"]

# Default command to launch MariaDB with specific configuration
CMD ["mysqld", "--bind-address=0.0.0.0"]