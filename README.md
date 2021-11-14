# Docker stack for local project on Symfony

## Basic info

* [Nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/)
* [Nginx](https://nginx.org/)
* [PHP](https://www.php.net/)
* [Postgres](https://www.postgresql.org/)
* [Rabbitmq](https://www.rabbitmq.com/)

## Previous requirements

This stack needs [docker](https://www.docker.com/) and [docker-compose](https://github.com/docker/compose/) to be installed.

## Installing

1. Clone this repository
2. Modify config in *.env* file
3. Create new or copy your project in *app/* dir
4. Run make command:
   ```sh
   make init
   ```
5. Don't forget add your domain-name to */etc/hosts*. For example:
   ```sh
   127.0.1.1    localhost
   ```

## How does it work?

We have the following *docker-compose* build image:

* `proxy`: The proxy server container for pretty domain names;
* `nginx`: The Nginx webserver container in which the application volume is mounted;
* `app`: The PHP container in which the application volume is mounted with Composer & Symfony CLI;
* `postgres`: Postgres database container;
* `rabbitmq`: Rabbitmq bus container.

## Makefile

To see all make commands run:
   ```sh
   make help
   ```