#!/bin/sh -e

# Enable debugging
if [ ! -z "$DEBUG" ]; then
    set -x
fi

# Set up environment
#. project-init.sh
#. apache-init.sh

# Insure proper permissions
#chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP "$(readlink -m ..)"

# Enable StrictHostKeyChecking (disabled in project-init)
#if [ -f $HOME/.ssh/config ]; then
#    sed -i "s/StrictHostKeyChecking no/StrictHostKeyChecking yes/"  $HOME/.ssh/config
#fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
        set -- apache2-foreground "$@"
fi

exec "$@"
