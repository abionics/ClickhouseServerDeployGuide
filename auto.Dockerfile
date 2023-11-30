FROM clickhouse/clickhouse-server:23.11.2.11-alpine

RUN apk add openssl
RUN mkdir /etc/clickhouse-server/certificate
# Certificate for 3 years (1095 days)
RUN openssl req -subj "/CN=localhost" -new -newkey rsa:2048 -days 1095 -nodes -x509 \
    -keyout /etc/clickhouse-server/certificate/clickhouse.key \
    -out /etc/clickhouse-server/certificate/clickhouse.crt
RUN chown -R clickhouse:clickhouse /etc/clickhouse-server/certificate
RUN chmod -R 755 /etc/clickhouse-server/certificate
