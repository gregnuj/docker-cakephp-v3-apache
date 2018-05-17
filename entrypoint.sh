#!/bin/sh -e

# Enable debugging
if [ ! -z "$DEBUG" ]; then
    set -x
fi

export WORKDIR="$(readlink -f .)"

# Import apache env vars
. $APACHE_ENVVARS

# Insure proper permissions
chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP "$(readlink -f ..)"

# store env 
printenv | egrep -v '^(_|PWD|PHP)' | awk -F '=' '{print $1"=\""$2"\""}' >> /etc/environment

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
        set -- apache2-foreground "$@"
fi

exec "$@"

