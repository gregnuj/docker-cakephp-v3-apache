#!/bin/sh

APT_CONF="${APT_CONF:="/etc/apt/apt.conf"}"
APT_CONF_D="${APT_CONF_D:="${APT_CONF}.d"}"
APT_CONF_PROXIES="${APT_CONF_PROXIES:="${APT_CONF_D}/proxies"}"

if [ -n "$HTTP_PROXY" ] then
    echo "Acquire::http::proxy \"$HTTP_PROXY\";" >> $APT_CONF_PROXIES
fi
if [ -n "$HTTPS_PROXY" ] then
    echo "Acquire::https::proxy \"$HTTPS_PROXY\";" >> $APT_CONF_PROXIES
fi

if [ -n "$ADD_PACKAGES" ]; then
    apt-get update \
        && apt-get install -y \
        $ADD_PACKAGES \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*
fi
