#!/bin/sh -e

# Enable debugging
if [ ! -z "$DEBUG" ]; then
    set -x
fi

declare -x WORKDIR="$(readlink -m .)"

## install project with git
if [ ! "$(ls -A ${WORKDIR})" ]; then
    if [ "$PROJECT_VCS_METHOD" = git ]; then
        if [ -n "$PROJECT_VCS_URL" ]; then
            git clone -b "$PROJECT_VCS_BRANCH" "$PROJECT_VCS_URL" "$(readlink -m .)"
            if [ -f "./composer.json" ]; then
                composer update
            fi
        fi

    ## install project with composer
    elif [ "$PROJECT_VCS_METHOD" = composer ]; then
        if [ ! -z "$PROJECT_NAME" ]; then
            /usr/bin/composer create-project \
                --stability=dev \
                --prefer-source \
                --no-interaction \
                --keep-vcs \
                $PROJECT_REPO/$PROJECT_NAME:dev-$PROJECT_VCS_BRANCH "$(readlink -m ..)"
        fi
    fi
fi

# Import apache env vars
. $APACHE_ENVVARS

# Insure proper permissions
chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP "$(readlink -m ..)"

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
        set -- apache2-foreground "$@"
fi

exec "$@"
