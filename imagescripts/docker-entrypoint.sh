#!/bin/bash

set -o errexit

function processCrucibleProxySettings() {
  if [ -n "${CRUCIBLE_PROXY_NAME}" ]; then
    xmlstarlet ed -P -S -L --insert "//http[not(@proxy-host)]" --type attr -n proxy-host --value "${CRUCIBLE_PROXY_NAME}" ${CRUCIBLE_INSTALL}/config.xml
  fi

  if [ -n "${CRUCIBLE_PROXY_PORT}" ]; then
    xmlstarlet ed -P -S -L --insert "//http[not(@proxy-port)]" --type attr -n proxy-port --value "${CRUCIBLE_PROXY_PORT}" ${CRUCIBLE_INSTALL}/config.xml
  fi

  if [ -n "${CRUCIBLE_PROXY_SCHEME}" ]; then
    xmlstarlet ed -P -S -L --insert "//http[not(@proxy-scheme)]" --type attr -n proxy-scheme --value "${CRUCIBLE_PROXY_SCHEME}" ${CRUCIBLE_INSTALL}/config.xml
  fi
}

if [ -n "${CRUCIBLE_DELAYED_START}" ]; then
  sleep ${CRUCIBLE_DELAYED_START}
fi

processCrucibleProxySettings

if [ "$1" = 'crucible' ] || [ "${1:0:1}" = '-' ]; then
  exec ${CRUCIBLE_INSTALL}/bin/run.sh
else
  exec "$@"
fi
