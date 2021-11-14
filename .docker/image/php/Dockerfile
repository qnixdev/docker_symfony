# Install base image
ARG PHP_VERSION

FROM php:${PHP_VERSION}-fpm-alpine3.14

LABEL author = 'Mykola Vyhivskyi <qnixdev@gmail.com>'
LABEL version = '1.0'
LABEL description = 'This image contains PHP modules and configurations to run project'

# Install packets
RUN set -ex; \
    \
    apk update \
    && apk upgrade \
    && apk add --no-cache \
        bash \
    ;

# Install PHP extensions
RUN curl -sSLf -o /usr/local/bin/install-php-extensions https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
    && chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions \
        amqp \
        gd \
        intl \
        pdo_pgsql \
        xsl \
        zip

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