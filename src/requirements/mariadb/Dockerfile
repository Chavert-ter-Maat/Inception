FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y mariadb-server

COPY ./start_mariadb.sh /start_mariadb.sh

RUN chmod +x /start_mariadb.sh

ENTRYPOINT ["./start_mariadb.sh"]