#!/bin/sh -e

# Enable debugging
if [ ! -z "$DEBUG" ]; then
    set -x
fi

# create project dir
if [ -n "$PROJECT_WORKDIR" ]; then
   mkdir -p "$PROJECT_WORKDIR"
   cd "$PROJECT_WORKDIR"
fi

# add key to user dir
mkdir -p ~/.ssh
if [ -n "$PROJECT_VCS_HOST" ]; then
    echo "\nHost $PROJECT_VCS_HOST" >> ~/.ssh/config
    echo "\tBatchMode yes" >> ~/.ssh/config
    echo "\tStrictHostKeyChecking no" >> ~/.ssh/config
    echo "\tPreferredAuthentications publickey" >> ~/.ssh/config
    [ -z "$PROJECT_VCS_RSA" ] || echo "\n\tIdentityFile $PROJECT_VCS_RSA" >> ~/.ssh/config
fi

