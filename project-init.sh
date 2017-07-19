#!/bin/sh -e

# Enable debugging
if [ ! -z "$DEBUG" ]; then
    set -x
fi

# add key to user dir
mkdir -p $HOME/.ssh
if [ -n "$PROJECT_VCS_HOST" ]; then
    echo "\nHost $PROJECT_VCS_HOST" >> $HOME/.ssh/config
    echo "\tBatchMode yes" >> $HOME/.ssh/config
    echo "\tStrictHostKeyChecking no" >> $HOME/.ssh/config
    echo "\tPreferredAuthentications publickey" >> $HOME/.ssh/config
    [ -z "$PROJECT_VCS_RSA" ] || echo "\n\tIdentityFile $PROJECT_VCS_RSA" >> $HOME/.ssh/config

    echo "{"                                           >> $COMPOSER_HOME/config.json
    echo "    \"repositories\": ["                     >> $COMPOSER_HOME/config.json
    echo "        {"                                   >> $COMPOSER_HOME/config.json
    echo "            \"url\":  \"PROJECT_VCS_HOST\"," >> $COMPOSER_HOME/config.json
    if [ -n $PROJECT_VCS_RSA ]; then
        echo "            \"options\": {"              >> $COMPOSER_HOME/config.json
        echo "                \"ssh2\": {"             >> $COMPOSER_HOME/config.json
        echo "                    \"privkey_file\": \"$PROJECT_VCS_RSA\"" >> $COMPOSER_HOME/config.json
        echo "                }"                       >> $COMPOSER_HOME/config.json
        echo "            },"                          >> $COMPOSER_HOME/config.json
    fi
    echo "            \"type\": \"vcs\""               >> $COMPOSER_HOME/config.json
    echo "        }"                                   >> $COMPOSER_HOME/config.json
    echo "    ]"                                       >> $COMPOSER_HOME/config.json
    echo "}"                                           >> $COMPOSER_HOME/config.json
fi
