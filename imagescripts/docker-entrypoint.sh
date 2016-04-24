#!/bin/bash

set -o errexit

if [ -n "${CRUCIBLE_DELAYED_START}" ]; then
  sleep ${CRUCIBLE_DELAYED_START}
fi

if [ "$1" = 'crucible' ] || [ "${1:0:1}" = '-' ]; then
  exec ${CRUCIBLE_INSTALL}/bin/run.sh
else
  exec "$@"
fi
