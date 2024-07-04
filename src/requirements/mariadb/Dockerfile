FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y mariadb-server nano

RUN mkdir -p /var/run/mysqld 
RUN chown -R mysql:mysql /var/run/mysqld && \
	chown -R mysql:mysql /var/lib/mysql && \
	chown -R mysql:mysql /etc/mysql

RUN chmod 777 /run/mysqld

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/start_mariadb.sh .

RUN chmod +x start_mariadb.sh

ENTRYPOINT ["./start_mariadb.sh"]