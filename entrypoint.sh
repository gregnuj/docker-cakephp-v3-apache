#!/bin/sh -e

# Enable debugging
if [ -n "$DEBUG" ]; then
    set -x
fi

export WORKDIR="$(readlink -m .)"

## install project with git
if [ "$PROJECT_VCS_METHOD" = git ]; then
    if [ -n "$PROJECT_VCS_URL" ]; then
        if [ ! "$(ls -A ${WORKDIR})" ]; then
            git clone -b "$PROJECT_VCS_BRANCH" "$PROJECT_VCS_URL" "$(readlink -m .)"
        else
            git stash save "container restart $(date +"%F_%T")"
            git pull
        fi
        if [ -f "./composer.json" ]; then
            composer update
        fi
    fi

## install project with composer
elif [ "$PROJECT_VCS_METHOD" = composer ]; then
    if [ ! -z "$PROJECT_NAME" ]; then
        if [ ! "$(ls -A ${WORKDIR})" ]; then
            /usr/bin/composer create-project \
                --stability=dev \
                --prefer-source \
                --no-interaction \
                --keep-vcs \
                $PROJECT_REPO/$PROJECT_NAME:dev-$PROJECT_VCS_BRANCH "$(readlink -m ..)"
        elif [ -f "./composer.json" ]; then
            composer update
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

# link service path
if [ -n "${APP_ALIAS}" ]; then 
    LINKTO="$(readlink -m ${WORKDIR}/../${APP_ALIAS})"
    if [ ! -e ${LINKTO} ]; then
        ln -s "${WORKDIR}" "${LINKTO}"
    fi
fi

# store env for reuse in cron
printenv | egrep -v '^(_|PWD|PHP)' | awk -F '=' '{print $1"=\""$2"\""}' >> /etc/environment

exec "$@"

