#!/bin/sh -e

# Enable debugging
if [ ! -z "$DEBUG" ]; then
    set -x
fi

CRON_DIR="${CRON_DIR:="/etc/cron.d"}"
CRON_FILE="${CRON_FILE:="${CRON_DIR}/crunz"}"
CRON_CMD="${CRON_CMD:="* * * * * root $(pwd)/vendor/lavary/crunz/crunz schedule:run"}"
CHECK_CRON="${CHECK_CRON:="true"}"
CHECK_FILE="${CHECK_FILE:="${CRON_DIR}/check"}"
CHECK_CMD='\5 * * * * root echo "$(date --utc +%FT%T.%3NZ) cron is running"'

mkdir -p ${CRON_DIR}
echo "${CRON_CMD}" > ${CRON_FILE}
chmod 755 ${CRON_FILE}
echo "${CHECK_CMD}" > ${CHECK_FILE}
chmod 755 ${CHECK_FILE}

