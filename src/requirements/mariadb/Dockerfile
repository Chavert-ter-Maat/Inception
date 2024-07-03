FROM debian:buster

RUN apt-get update -y

RUN apt-get install -y mariadb-server

RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chown -R mysql:mysql /etc/mysql

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/start_mariadb.sh /
COPY ./conf/init.sql /init.sql

RUN chown mysql:mysql /start_mariadb.sh
RUN chmod +x /start_mariadb.sh

ENTRYPOINT [ "/start_mariadb.sh" ]
CMD [ "mysqld" ]