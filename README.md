# Clickhouse Server Deploy Guide

> **Note**
> Don't forget to star this repo if you like it! ⭐

> **Warning**
> Don't use certificates from this guide in production! They are real, but publicly available ❗

This guide will help you quickly deploy a clickhouse server with SSL encryption and a grafana monitoring with SSL encryption.
For grafana configuration, see [this official guide](https://clickhouse.com/blog/visualizing-data-with-grafana)

## Navigation

* [🔐 Certificate Notes](#-certificate-notes)
* [📝 Env](#-env)
* [👌 Default [✍️ self-signed]](#-default)
* [🚀 Auto-certificate [✍️ self-signed]](#-auto-certificate--self-signed)
    * [Quick start](#quick-start)
    * [Volumes](#volumes)
    * [Ports](#ports)
    * [Files](#files)
* [🏭 Chproxy](#-chproxy)
    * [Quick start](#quick-start-1)
    * [Volumes](#volumes-1)
    * [Ports](#ports-1)
    * [Config](#config)
    * [Files](#files-1)
* [⚠️ Insecure (http)](#-insecure-http)
    * [Quick start](#quick-start-2)
    * [Volumes](#volumes-2)
    * [Ports](#ports-2)
    * [Files](#files-2)


## 🔐 Certificate Notes

This guide provides information on both normal SSL certificates and self-signed certificates.
When referring to self-signed certificates, I will use the `[✍️ self-signed]` note in the text.
Please note that for local development on localhost, you must follow the procedure for self-signed certificates.



## 📝 Env

* `CLICKHOUSE_DB` - database for clickhouse
* `CLICKHOUSE_USER` - user for clickhouse
* `CLICKHOUSE_PASSWORD` - password for clickhouse
* `GF_SECURITY_ADMIN_USER` - user for grafana
* `GF_SECURITY_ADMIN_PASSWORD` - password for grafana

See [.env](.env) file for demo



## 👌 Default

### Quick start

Start:
```bash
docker-compose up
```

Connection:
```bash
echo "SELECT 1" | curl 'https://ch-user:ch-password@localhost:8443' --data-binary @-

# [✍️ self-signed]
echo "SELECT 1" | curl 'https://ch-user:ch-password@localhost:8443' --data-binary @- --insecure
```

```bash
./clickhouse client --host localhost --port 9440 --user ch-user --password ch-password --secure

# [✍️ self-signed]
./clickhouse client --host localhost --port 9440 --user ch-user --password ch-password --secure --accept-invalid-certificate
```

DataGrip:
* Port: `8443`
* User: `ch-user`
* Password: `ch-password`
* Database: `default`
* Advance -> ssl: `true`
* Advance -> sslmode: `STRICT` or `NONE` for **[✍️ self-signed]**

**Grafana:** [https://localhost:3000](https://localhost:3000)


### Volumes

* **clickhouse-data** - persistent data for clickhouse
* [clickhouse-users.xml](docker/clickhouse-users.xml) - users for clickhouse
* [clickhouse-config-ssl.xml](docker/clickhouse-config-ssl.xml) - config for clickhouse, modified for SSL
* **grafana-data** - persistent data for grafana
* [certificate/clickhouse](docker/certificate/clickhouse) - SSL certificate for clickhouse
* [certificate/grafana](docker/certificate/grafana) - SSL certificate for grafana


### Ports

* `8443` - https port **(encrypted)**
* `9440` - native port **(encrypted)**
* `3000` - grafana port **(encrypted)**


### Files

* .env
* Dockerfile
* docker-compose-auto.yml
* docker/:
    * clickhouse-users.xml
    * clickhouse-config-ssl.xml 
    * certificate/:
        * clickhouse/:
            * clickhouse.crt
            * clickhouse.key
        * grafana/:
            * grafana.crt
            * grafana.key



## 🚀 Auto-certificate [✍️ self-signed]

### Quick start

Start:
```bash
docker-compose -f docker-compose-auto.yml up
```

Connection:
```bash
echo "SELECT 1" | curl 'https://ch-user:ch-password@localhost:8443' --data-binary @-

# [✍️ self-signed]
echo "SELECT 1" | curl 'https://ch-user:ch-password@localhost:8443' --data-binary @- --insecure
```

```bash
./clickhouse client --host localhost --port 9440 --user ch-user --password ch-password --secure

# [✍️ self-signed]
./clickhouse client --host localhost --port 9440 --user ch-user --password ch-password --secure --accept-invalid-certificate
```

DataGrip:
* Port: `8443`
* User: `ch-user`
* Password: `ch-password`
* Database: `default`
* Advance -> ssl: `true`
* Advance -> sslmode: `STRICT` or `NONE` for **[✍️ self-signed]**

**Grafana:** [https://localhost:3000](https://localhost:3000)


### Volumes

* **clickhouse-data** - persistent data for clickhouse
* [clickhouse-users.xml](docker/clickhouse-users.xml) - users for clickhouse
* [clickhouse-config-ssl.xml](docker/clickhouse-config-ssl.xml) - config for clickhouse, modified for SSL
* **grafana-data** - persistent data for grafana
* [certificate/grafana](docker/certificate/grafana) - SSL certificate for grafana


### Ports

* `8443` - https port **(encrypted)**
* `9440` - native port **(encrypted)**
* `3000` - grafana port **(encrypted)**


### Files

* .env
* Dockerfile
* docker-compose-auto.yml
* docker/:
    * clickhouse-users.xml
    * clickhouse-config-ssl.xml 
    * certificate/grafana/:
        * grafana.crt
        * grafana.key



## 🏭 Chproxy

> **Warning**
> In this scenario, you can only connect using the `https` protocol, not the `native` protocol

### Quick start

Generate certificate (is case of `[✍️ self-signed]`):
```bash
openssl req -subj "/CN=localhost" -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout clickhouse.key -out clickhouse.crt
```

Start:
```bash
docker-compose -f docker-compose-chproxy.yml up
```

Connection:
```bash
echo "SELECT 1" | curl 'https://chproxy-user:chproxy-password@localhost:9090' --data-binary @-

# [✍️ self-signed]
echo "SELECT 1" | curl 'https://chproxy-user:chproxy-password@localhost:9090' --data-binary @- --insecure
```

DataGrip:
* Port: `9090`
* User: `chproxy-user`
* Password: `chproxy-password`
* Database: `default`
* Advance -> ssl: `true`
* Advance -> sslmode: `STRICT` or `NONE` for **[✍️ self-signed]**

**Grafana:** [https://localhost:3000](https://localhost:3000)


### Volumes

* [chproxy-config.yml](docker/chproxy-config.yml) - chproxy config
* [chproxy-certificate](docker/certificate/chproxy) - SSL certificate for chproxy
* **clickhouse-data** - persistent data for clickhouse
* [clickhouse-users.xml](docker/clickhouse-users.xml) - users for clickhouse
* [clickhouse-config.xml](docker/clickhouse-config.xml) - config for clickhouse, unmodified
* **grafana-data** - persistent data for grafana
* [certificate/grafana](docker/certificate/grafana) - SSL certificate for grafana

### Ports

* `9090` - chproxy port **(encrypted)**
* `3000` - grafana port **(encrypted)**


### Config

* `autocert` - Let's Encrypt SSL certificate
* `cert_file` and `key_file` - any other SSL certificate
* `allowed_networks` - list of allowed networks, **highly recommended to use**


### Files

* .env
* docker-compose-chproxy.yml
* docker/:
    * chproxy-config.yml
    * chproxy-certificate:
        * chproxy.crt
        * chproxy.key
    * clickhouse-users.xml
    * clickhouse-config.xml
    * certificate/grafana/:
        * grafana.crt
        * grafana.key



## ⚠️ Insecure (http)

### Quick start

> **Warning**
> Don't use this because http traffic is not encrypted and can be intercepted

Start:
```bash
docker-compose -f docker-compose-insecure.yml up
```

Connection:
```bash
echo "SELECT 1" | curl 'http://ch-user:ch-password@localhost:8123' --data-binary @-
```

```bash
./clickhouse client --host localhost --port 9000 --user ch-user --password ch-password
```

DataGrip:
* Port: `8123`
* User: `ch-user`
* Password: `ch-password`
* Database: `default`
* Advance -> ssl: `false`

**Grafana:** [http://localhost:3000](http://localhost:3000)


### Volumes

* **clickhouse-data** - persistent data for clickhouse
* [clickhouse-users.xml](docker/clickhouse-users.xml) - users for clickhouse
* [clickhouse-config.xml](docker/clickhouse-config.xml) - config for clickhouse, unmodified
* **grafana-data** - persistent data for grafana


### Ports

* `8123` - http port **(unencrypted)**
* `9000` - native port **(unencrypted)**
* `3000` - grafana port **(unencrypted)**


### Files

* .env
* docker-compose-insecure.yml
* docker/:
    * clickhouse-users.xml
    * clickhouse-config.xml
