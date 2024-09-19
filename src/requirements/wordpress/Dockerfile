FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y curl php php7.4-fpm php-mysql mariadb-client netcat

COPY ./start_wp.sh /

RUN  chmod +x start_wp.sh

ENTRYPOINT ["./start_wp.sh"]