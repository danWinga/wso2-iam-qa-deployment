#!/bin/sh

set -e

if [ "${DRIVER_DBM_ORACLE}" = "true" ]; then
  if [ "${DRIVER_DBM_ORACLE_URL}" != "" ]; then
    echo "Enabled driver for Oracle (${DRIVER_DBM_ORACLE_URL})."
    curl -sL "${DRIVER_DBM_ORACLE_URL}" -o $1
  else
    echo "Enabled driver for Oracle (ojdbc6.jar)."
    cp -v ${USER_HOME}/resources/libs/ojdbc6.jar $1
  fi
fi

if [ "${DRIVER_DBM_MYSQL}" = "true" ]; then
  if [ "${DRIVER_DBM_MYSQL_URL}" != "" ]; then
    echo "Enabled driver for MySQL (${DRIVER_DBM_MYSQL_URL})."
    curl -sL "${DRIVER_DBM_MYSQL_URL}" -o $1
  else
    echo "Enabled driver for MySQL (mysql-connector-java-5.1.48.jar)."
    cp -v ${USER_HOME}/resources/libs/mysql-connector-java-5.1.48.jar $1
  fi
fi

if [ "${DRIVER_DBM_MSQL}" = "true" ]; then
  if [ "${DRIVER_DBM_MSQL_URL}" != "" ]; then
    echo "Enabled driver for Microsoft SQL (${DRIVER_DBM_MSQL_URL})."
    curl -sL "${DRIVER_DBM_MSQL_URL}" -o $1
  else
    echo "Enabled driver for Microsoft SQL (sqljdbc4-2.0.jar)."
    cp -v ${USER_HOME}/resources/libs/sqljdbc4-2.0.jar $1
  fi
fi

if [ "${DRIVER_DBM_POSTGRESQL}" = "true" ]; then
  if [ "${DRIVER_DBM_POSTGRESQL_URL}" != "" ]; then
    echo "Enabled driver for Postgress (${DRIVER_DBM_POSTGRESQL_URL})."
    curl -sL "${DRIVER_DBM_POSTGRESQL_URL}" -o $1
  else
    echo "Enabled driver for Postgress (postgresql-42.2.8.jar)."
    cp -v ${USER_HOME}/resources/libs/postgresql-42.2.8.jar $1
  fi
fi
