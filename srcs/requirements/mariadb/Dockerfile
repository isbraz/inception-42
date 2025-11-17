FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration files
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init-db.sh /usr/local/bin/init-db.sh

RUN chmod +x /usr/local/bin/init-db.sh

# Create directory for MariaDB runtime files
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

EXPOSE 3306

CMD ["/usr/local/bin/init-db.sh"]
