# Start from Debian Buster base image
FROM debian:buster

# Update package lists and install necessary packages
RUN apt-get update && apt-get -y install \
    wget \
    curl \
    bash \
    php \
    php-cgi \
    php-mysql \
    php-fpm \
    php-pdo \
    php-gd php-cli \
    php-mbstring \
    redis \
    php-redis \
    && rm -rf /var/lib/apt/lists/*

# Install wp_cli command and place it in /usr/local/bin
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy www.conf configuration file to PHP-FPM pool directory
COPY ./configs/www.conf /etc/php/7.3/fpm/pool.d/

# Create directory for PHP to enable startup
RUN mkdir /run/php

# Copy the start.sh script and make it executable
COPY ./tools/start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

# Set the entry point to execute the start.sh script
ENTRYPOINT ["/usr/local/bin/start.sh"]

# Set working directory to /var/www/html where the application will run
WORKDIR /var/www/html/

# Expose port 9000 to allow PHP-FPM to accept connections
EXPOSE 9000

# Launch PHP-FPM in foreground mode and ignore daemonize option from the configuration file (-F)
CMD ["/usr/sbin/php-fpm7.3", "-F"]