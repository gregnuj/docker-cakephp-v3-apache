#!/bin/sh -e

# Enable debugging
if [ ! -z "$DEBUG" ]; then
    set -x
fi

CRON_DIR="${CRON_DIR:="/etc/cron.d"}"
CRON_FILE="${CRON_FILE:="${CRON_DIR}/crunz"}"
CRON_CMD="${CRON_CMD:="* * * * * root $WORKDIR/vendor/lavary/crunz/crunz schedule:run"}"

mkdir -p ${CRON_DIR}
echo "${CRON_CMD}" > ${CRON_FILE}
chmod 755 ${CRON_FILE}

