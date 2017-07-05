#!/bin/sh -e

# Enable debugging
if [ ! -z "$DEBUG" ]; then
    set -x
fi

# Set up environment
. project-init.sh
. apache-init.sh

## install project with git
if [ "$PROJECT_VCS_METHOD" = git ]; then
    if [ -n "$PROJECT_VCS_URL" ]; then
        cd "$PROJECT_WORKDIR"
        git clone -b "$PROJECT_VCS_BRANCH" "$PROJECT_VCS_URL" "./$PROJECT_APPDIR"
        chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP ./$PROJECT_APPDIR
        cd "$PROJECT_APPDIR"
        if [ -f "./composer.json" ]; then
            composer update
        fi
    fi

## install project with composer
else
    if [ ! -z "$PROJECT_VCS_URL" ]; then
        /usr/bin/composer config --global repositories.0 "{\"type\": \"vcs\", \"url\": \"$PROJECT_VCS_URL\"}"
    fi

    if [ ! -z "$PROJECT_NAME" ]; then
        /usr/bin/composer create-project \
          --stability=dev \
          --prefer-source \
          --no-interaction \
          --keep-vcs \
          $PROJECT_REPO/$PROJECT_NAME $PROJECT_WORKDIR
    fi
fi

# Modify DocumentRoot
sed -i 's/DocumentRoot \/var\/www\/html/&\/goset/' /etc/apache2/sites-available/*default*

# Enable StrictHostKeyChecking (disabled in project-init)
if [ -f $HOME/.ssh/config ]; then
    sed -i "s/StrictHostKeyChecking no/StrictHostKeyChecking yes/"  $HOME/.ssh/config
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
        set -- apache2-foreground "$@"
fi

exec "$@"
