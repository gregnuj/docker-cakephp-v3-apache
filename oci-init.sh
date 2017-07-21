#!/bin/sh

if [ -n "$ENABLE_OCI8" ]; then
    CLIENT_ZIP="/opt/src/instantclient-basiclite-linux.x64-12.2.0.1.0.zip"

    export ORACLE_BASE="/usr/lib/instantclient_12_2"
    export LD_LIBRARY_PATH="$ORACLE_BASE"
    export TNS_ADMIN="$ORACLE_BASE" 
    export ORACLE_HOME=="$ORACLE_BASE"


    if [ -f "$ORACLE_CLIENT_ZIP" ]; then
        unzip $ORACLE_CLIENT_ZIP -d $(readlink -m $ORACLE_BASE/../)
        ln -s $ORACLE_BASE/libclntsh.so.12.2 $(readlink -m $ORACLE_BASE/../libclntsh.so) 
        ln -s $ORACLE_BASE/libocci.so.12.2 $(readlink -m $ORACLE_BASE/../libocci.so)
        ln -s $ORACLE_BASE/libociei.so $(readlink -m $ORACLE_BASE/../libociei.so)
        ln -s $ORACLE_BASE/libnnz12.so $(readlink -m $ORACLE_BASE/../libnnz12.so)
    fi

    # install oci8
    docker-php-ext-install oci8
fi
