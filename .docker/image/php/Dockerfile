# Install base image
ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm-alpine3.14

LABEL maintainer="Mykola Vyhivskyi <qnixdev@gmail.com>" \
      version="1.0"

# Install packets
RUN set -ex; \
    \
    apk upgrade --update && apk add --no-cache \
        bash \
    ; \
    \
    # Install libraries
    apk add --no-cache --virtual .build-deps \
        icu-dev \
        imagemagick-dev \
        libxslt-dev \
        libzip-dev \
        postgresql-dev \
        rabbitmq-c-dev \
    ; \
    \
    # Add amqp & imagick support
    docker-php-source extract \
    && mkdir /usr/src/php/ext/amqp \
    && curl -L https://github.com/php-amqp/php-amqp/archive/master.tar.gz | tar -xzC /usr/src/php/ext/amqp --strip-components=1 \
    && mkdir /usr/src/php/ext/imagick \
    && curl -L https://github.com/imagick/imagick/archive/master.tar.gz | tar -xzC /usr/src/php/ext/imagick --strip-components=1 \
    ; \
    \
    # Add postgres support
    docker-php-ext-configure pgsql \
        -with-pgsql=/usr/local/pgsql \
    ; \
    \
    # Install PHP compiled extensions
    docker-php-ext-install -j "$(nproc)" \
        amqp \
        imagick \
        intl \
        pdo_pgsql \
        xsl \
        zip \
    ; \
    \
    # Delete PHP source
    docker-php-source delete \
    ; \
    \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --virtual .php-ext $runDeps; \
    apk del .build-deps

# Configure PHP
RUN { \
    echo 'memory_limit=256M'; \
    echo 'upload_max_filesize=64M'; \
    echo 'post_max_size=128M'; \
} > /usr/local/etc/php/conf.d/local.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Install Symfomy CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony/bin/symfony /usr/local/bin/symfony

# Set workdir
WORKDIR /app

# Copy app file
COPY . .

# Add user & group
ARG USER_APP
ARG GROUP_APP
ARG UID
ARG GID

RUN addgroup -g ${UID} ${GROUP_APP} \
    && adduser -D -u ${GID} -G ${GROUP_APP} ${USER_APP} \
    && mkdir -p /home/${USER_APP}/.ssh \
    && chmod -R 600 /home/${USER_APP}/.ssh \
    && chown -R ${USER_APP}:${GROUP_APP} /home/${USER_APP}/.ssh

USER ${USER_APP}