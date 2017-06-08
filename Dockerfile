FROM php:5.6-apache

LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"

## Install project requirements
RUN apt-get update \
    && apt-get install -y \
    bash curl git \
    libmcrypt4 libicu52 \
    libmcrypt-dev g++ libicu-dev zlib1g-dev git libxml2-dev \
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

## Set up project enviroment
ENV \
    PROJECT_REPO="" \
    PROJECT_NAME="" \
    PROJECT_WORKDIR="" \
    PROJECT_APPDIR="" \
    PROJECT_VCS_HOST="" \
    PROJECT_VCS_RSA="" \
    PROJECT_VCS_URL="" \
    PROJECT_VCS_BRANCH="" 

## Create entrypoint scripts
COPY *entrypoint /usr/local/bin/
RUN chmod 755 /usr/local/bin/*entrypoint 

EXPOSE 80
ENTRYPOINT ["/usr/local/bin/docker-git-entrypoint"]
CMD ["apache2-foreground"]
