#!/bin/sh -e

# Enable debugging
if [ ! -z "$DEBUG" ]; then
    set -x
fi

# Import apache environment
. $APACHE_ENVVARS

# create project dir
. project-init

chown -R $APACHE_RUN_USER:$APACHE_RUN_GROUP "$PROJECT_WORKDIR"

