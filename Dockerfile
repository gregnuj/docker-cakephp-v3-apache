FROM php:5.6-apache

LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"

## Install project requirements
RUN apt-get update \
    && apt-get install -y \
    bash curl git vim cron openssh-client \
    g++ libmcrypt4 libicu52 zlib1g-dev \
    libmcrypt-dev libicu-dev libxml2-dev libpq-dev \
    libssh2-1-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

## Install project php extensions
RUN docker-php-ext-install \
    mcrypt \
    mbstring \
    pdo_mysql \
    pdo_pgsql \
    intl \
    soap \
    zip 

RUN pecl install ssh2 \
    && docker-php-ext-enable ssh2

## Set up composer enviroment
ENV PATH="/composer/vendor/bin:$PATH" \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/composer \
    COMPOSER_VERSION=1.3.3

## Install composer
RUN curl -s -f -L -o /tmp/installer.php https://raw.githubusercontent.com/composer/getcomposer.org/da290238de6d63faace0343efbdd5aa9354332c5/web/installer \
    && php -r " \
        \$signature = '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410'; \
        \$hash = hash('SHA384', file_get_contents('/tmp/installer.php')); \
        if (!hash_equals(\$signature, \$hash)) { \
            unlink('/tmp/installer.php'); \
            echo 'Integrity check failed, installer is either corrupt or worse.' . PHP_EOL; \
            exit(1); \
        }" \
    && php /tmp/installer.php --no-ansi --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION} \
    && rm /tmp/installer.php \
    && composer self-update \
    && composer --ansi --version --no-interaction

## Set up project enviroment
ENV \
    PROJECT_REPO="cakephp" \
    PROJECT_NAME="cakephp:3.*" \
    PROJECT_VCS_HOST="" \
    PROJECT_VCS_RSA="" \
    PROJECT_VCS_URL="" \
    PROJECT_VCS_BRANCH="master" 

## Enable mod rewrite
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
RUN a2enmod rewrite

## Copy entrypoint script(s)
COPY *.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/*.sh

## cake.php uses /usr/bin/php
RUN ln -s /usr/local/bin/php /usr/bin/php

EXPOSE 80
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["apache2-foreground"]
