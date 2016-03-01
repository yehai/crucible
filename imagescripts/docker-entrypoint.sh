#!/bin/bash

set -o errexit

function processCrucibleProxySettings() {
  if [ -n "${CRUCIBLE_PROXY_NAME}" ]; then
    xmlstarlet ed -P -S -L --insert "//Connector[not(@proxyName)]" --type attr -n proxyName --value "${CRUCIBLE_PROXY_NAME}" ${CRUCIBLE_INSTALL}/conf/server.xml
  fi

  if [ -n "${CRUCIBLE_PROXY_PORT}" ]; then
    xmlstarlet ed -P -S -L --insert "//Connector[not(@proxyPort)]" --type attr -n proxyPort --value "${CRUCIBLE_PROXY_PORT}" ${CRUCIBLE_INSTALL}/conf/server.xml
  fi

  if [ -n "${CRUCIBLE_PROXY_SCHEME}" ]; then
    xmlstarlet ed -P -S -L --insert "//Connector[not(@scheme)]" --type attr -n scheme --value "${CRUCIBLE_PROXY_SCHEME}" ${CRUCIBLE_INSTALL}/conf/server.xml
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
