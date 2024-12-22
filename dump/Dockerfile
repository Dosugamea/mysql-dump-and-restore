FROM alpine:3.18

# mariadb-connector-c is required for mysql 8.0 or upper if use caching_sha2_password
RUN apk add --no-cache mariadb-connector-c mysql-client aws-cli bash gzip

COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

CMD ["/usr/local/bin/backup.sh"]
