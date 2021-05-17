# Docker stack for local project on Symfony

## Basic info

* [Nginx](https://nginx.org/)
* [Nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy)
* [PHP](https://www.php.net/)
* [Composer](https://getcomposer.org/)
* [Symfony CLI](https://symfony.com/)
* [Postgres](https://www.postgresql.org/)
* [Redis](https://redis.io/)

## Previous requirements

This stack needs [docker](https://www.docker.com/) and [docker-compose](https://github.com/docker/compose/) to be installed.

## Installing

1. Clone this repository

2. Modify configuration in the *.env* file

3. Run docker-compose:

    ```sh
    docker-compose up -d --build
    ```

4. Go inside container:

    ```sh
    docker exec -it app bash
    ```

5. Now your make to install the new Symfony project:

    ```sh
    symfony new --full my_project
    ```

## How does it work?

We have the following *docker-compose* build image:

* `nginx`: The Nginx webserver container in which the application volume is mounted;
* `nginx-proxy`: The proxy server container for pretty domain names;
* `app`: The PHP container in which the application volume is mounted;
* `postgres`: The Postgres database container;
* `redis`: The Redis server container.