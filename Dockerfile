FROM clickhouse/clickhouse-server:23.4.2.11-alpine

RUN apk add openssl
# Certificate for 3 years (1095 days)
RUN openssl req -subj "/CN=localhost" -new -newkey rsa:2048 -days 1095 -nodes -x509 \
    -keyout /etc/clickhouse-server/server.key \
    -out /etc/clickhouse-server/server.crt
RUN chown clickhouse:clickhouse /etc/clickhouse-server/server.*
RUN chmod 755 /etc/clickhouse-server/server.*
