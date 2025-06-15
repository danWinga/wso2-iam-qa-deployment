#!/bin/sh

set -e

if [ -d "${USER_HOME}/siddhi-files" ]; then
  echo "Checking control file -> ${USER_HOME}/siddhi-files/OK_MOUNT.txt"
  if [ ! -f ${USER_HOME}/siddhi-files/OK_MOUNT.txt ]; then
    echo "Populating the folder -> ${USER_HOME}/siddhi-files"
    cp -r ${CARBON_PATH}/wso2/manager/deployment/siddhi-files/* ${USER_HOME}/siddhi-files
    touch ${USER_HOME}/siddhi-files/OK_MOUNT.txt
  fi
  echo "Linking volume -> ${USER_HOME}/siddhi-files"
  rm -rf ${CARBON_PATH}/wso2/manager/deployment/siddhi-files
  ln -s ${USER_HOME}/siddhi-files/ ${CARBON_PATH}/wso2/manager/deployment/siddhi-files
  echo "Overwriting /config-siddhi-files"
  test -d ${USER_HOME}/config-siddhi-files && cp -RvTL ${USER_HOME}/config-siddhi-files ${USER_HOME}/siddhi-files
fi

if [ -d "${USER_HOME}/config" ]; then
  echo "Overwrite /config. to ${CARBON_PATH}"
  cp -RvT ${USER_HOME}/config ${CARBON_PATH}
fi


echo "Applied DBMS configuration..."
sh ${USER_HOME}/resources/scripts/dbms.sh ${CARBON_PATH}/lib

echo "Starting server..."
sh ${CARBON_PATH}/bin/${CARBON_SCRIPT} "$@"
