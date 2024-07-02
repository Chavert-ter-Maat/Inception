# Use an appropriate base image, for example Debian Buster
FROM debian:buster

# Update package lists and install nginx and openssl
RUN apt-get update \
    && apt-get install -y nginx openssl \
    && rm -rf /var/lib/apt/lists/*

# Create directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Generate SSL certificate and key
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out /etc/nginx/ssl/ctermaa.crt \
    -keyout /etc/nginx/ssl/cter-maa.key \
	-subj "/CN=ctermaa.com/O=Chaverts company/C=NL"

# Copy nginx configuration file
COPY ./configs/nginx.conf /etc/nginx/conf.d/

# Create directory for nginx runtime files
RUN mkdir -p /run/nginx

# Expose port 443 (HTTPS)
EXPOSE 443

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]