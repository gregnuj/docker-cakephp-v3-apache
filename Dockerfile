FROM php:5.6-apache

LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"

## Install project requirements
RUN apt-get update \
    && apt-get install -y \
    nodejs npm \
    bash cron curl git socat unzip vim openssh-client \
    g++ libmcrypt4 libicu52 zlib1g-dev \
    libmcrypt-dev libicu-dev libxml2-dev libpq-dev \
    libssh2-1-dev libz-dev libmemcached-dev \
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
    sockets \
    zip 

RUN pecl install memcached redis ssh2 \
    && docker-php-ext-enable memcached \
    && docker-php-ext-enable redis \
    && docker-php-ext-enable ssh2 

## Set up composer enviroment
ENV PATH="/composer/vendor/bin:$PATH" \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/composer \
    COMPOSER_VERSION=1.3.3

## Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer --ansi --version --no-interaction

## Install npm
RUN npm install -g grunt --save-dev

## Set up project enviroment
ENV \
    PROJECT_REPO="cakephp" \
    PROJECT_NAME="cakephp:3.*" \
    PROJECT_VCS_HOST="github.com" \
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
