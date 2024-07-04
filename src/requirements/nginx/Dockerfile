FROM debian:buster

# Update packages and install necessary dependencies
RUN apt-get update -y \
    && apt-get install -y nginx openssl curl libfcgi0ldbl

# Create directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Copy Nginx config file and start script
COPY conf/nginx.conf /etc/nginx/sites-available/default
COPY ./tools/start_nginx.sh /start_nginx.sh

# Make the start script executable
RUN chmod +x /start_nginx.sh

# Remove default symlink and create a new one for our config
RUN rm -f /etc/nginx/sites-enabled/default && \
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Generate a self-signed SSL certificate
RUN openssl req -x509 -nodes -newkey rsa:2048 -out /etc/nginx/ssl/cter-maa.crt -keyout /etc/nginx/ssl/cter-maa.key -subj "/CN=cter-maa.42.fr"

# Expose port 443 for HTTPS access
EXPOSE 443

# Set entrypoint to start script
ENTRYPOINT [ "/start_nginx.sh" ]