FROM php:7.1-apache

LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"

## Install project requirements
RUN apt-get update \
    && apt-get install -y \
    bash curl git vim cron socat unzip openssh-client \
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
    sockets \
    zip 

RUN pecl install ssh2 \
    && docker-php-ext-enable ssh2

## Enable mod rewrite
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
RUN a2enmod rewrite

## Copy entrypoint script(s)
#COPY *.sh /usr/local/bin/
#RUN chmod 755 /usr/local/bin/*.sh

## cake.php uses /usr/bin/php
RUN ln -s /usr/local/bin/php /usr/bin/php

EXPOSE 80
#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["apache2-foreground"]
