#!/bin/sh -e

# Enable debugging
if [ ! -z "$DEBUG" ]; then
    set -x
fi

# copy /configs files
configs="$(find /configs/ -type f -exec ls  {} \; 2> /dev/null | awk  '!/\/\./{print substr($0,9)}')"
if [ -n "$configs" ]; then 
    for config in $configs; do
        cp --preserve=all "/configs/${config}" "${config}"
    done;
fi

# set workdir variable internally
export WORKDIR="$(readlink -f .)"

# Import apache env vars
. $APACHE_ENVVARS

# Insure proper permissions
chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP "$(readlink -f ..)"


# store env in /etc/environment
printenv | egrep -v '^(_|PWD|PHP)' | awk -F '=' '{print $1"=\""$2"\""}' >> /etc/environment

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
        set -- apache2-foreground "$@"
fi

exec "$@"
