# Clickhouse Server Deploy Guide

## Navigation

* [🔐 Certificate Notes](#-certificate-notes)
* [📝 Env](#-env)
* [🚀 Native auto-certificate [✍️ self-signed]](#-native-auto-certificate--self-signed)
    * [Quick start](#quick-start)
    * [Volumes](#volumes)
    * [Ports](#ports)
    * [Files](#files)
* [😎 Native normal certificate](#-native-normal-certificate)
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

See [.env](.env) file for demo



## 🚀 Native auto-certificate [✍️ self-signed]

### Quick start

Start:
```bash
docker-compose up
```

Usage:
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

### Volumes

* [clickhouse-data](docker/clickhouse-data) - persistent data for clickhouse
* [clickhouse-users.xml](docker/clickhouse-users.xml) - users for clickhouse
* [clickhouse-config-ssl.xml](docker/clickhouse-config.xml) - config for clickhouse, modified for SSL


### Ports

* `8443` - https port
* `9440` - native port **(encrypted)**


### Files

* .env
* Dockerfile
* docker-compose.yml
* docker/:
    * clickhouse-users.xml
    * clickhouse-config-ssl.xml



## 😎 Native normal certificate

[//]: # (todo)
todo



## 🏭 Chproxy

> **Warning**
> In this scenario, you can only connect using the `https` protocol, not the `native` protocol

### Quick start

Start:
```bash
docker-compose -f docker-compose-chproxy.yml up
```

Usage:
```bash
echo "SELECT 1" | curl 'https://chproxy-user:chproxy-password@localhost:9090' --data-binary @-

# [✍️ self-signed]
echo "SELECT 1" | curl 'https://chproxy-user:chproxy-password@localhost:9090' --data-binary @- --insecure
```

DataGrip:
* Port: `9090`
* User: `chproxy-user`
* Password: `chproxy-password`
* Database: as in [Native](#-native-auto-certificate--self-signed)
* Advance -> ssl: as in [Native](#-native-auto-certificate--self-signed)
* Advance -> sslmode: as in [Native](#-native-auto-certificate--self-signed)

### Volumes

* [chproxy-config.yml](docker/chproxy-config.yml) - for chproxy config
* [chproxy-certificate](docker/chproxy-certificate) - for chproxy SSL certificate
* [clickhouse-data](docker/clickhouse-data) - as in [Native](#-native-auto-certificate--self-signed)
* [clickhouse-users.xml](docker/clickhouse-users.xml) - as in [Native](#-native-auto-certificate--self-signed)
* [clickhouse-config.xml](docker/clickhouse-config.xml) - config for clickhouse, unmodified

### Ports

* `9090` - chproxy port **(encrypted)**


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



## ⚠️ Insecure (http)

### Quick start

> **Warning**
> Don't use this because http traffic is not encrypted and can be intercepted

Start:
```bash
docker-compose -f docker-compose-insecure.yml up
```

Usage:
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

### Volumes

* [clickhouse-data](docker/clickhouse-data) - persistent data for clickhouse
* [clickhouse-users.xml](docker/clickhouse-users.xml) - users for clickhouse
* [clickhouse-config.xml](docker/clickhouse-config.xml) - config for clickhouse, unmodified


### Ports

* `8123` - http port
* `9000` - native port **(unencrypted)**


### Files

* .env
* docker-compose-insecure.yml
* docker/:
    * clickhouse-users.xml
    * clickhouse-config.xml
