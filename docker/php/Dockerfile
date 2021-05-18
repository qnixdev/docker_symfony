# Install base image
ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm-alpine

RUN set -ex; \
    \
    # Install packets
    apk update && apk upgrade && apk add --no-cache \
        bash \
    ; \
    \
    # Install libraries
    apk add --no-cache --virtual .build-deps \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libzip-dev \
        postgresql-dev \
    ; \
    \
    # Add gd support
    docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg; \
    \
    # Add postgres support
    docker-php-ext-configure pgsql \
        -with-pgsql=/usr/include/postgresql/; \
    \
    # Add redis support
    pecl install -o -f redis && rm -rf /tmp/pear; \
    echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini; \
    \
    # PHP compiled extensions
    docker-php-ext-install \
        gd \
        intl \
        opcache \
        pdo_pgsql \
        zip \
    ; \
    \
    runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --virtual .symfony-php-ext $runDeps; \
    apk del .build-deps

# Configure PHP
# see https://secure.php.net/manual/en/opcache.installation.php
COPY opcache.ini /usr/local/etc/php/conf.d/ext-opcache.ini

RUN { \
        echo 'memory_limit=256M'; \
        echo 'upload_max_filesize=64M'; \
        echo 'post_max_size=128M'; \
    } > /usr/local/etc/php/conf.d/ext-recommended.ini

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
