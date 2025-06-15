#!/bin/sh

set -e

echo "Started - $(date)"

echo "Checked passwords..."
if [ ! -f ${USER_HOME}/ciphertool-password ]; then
  echo "wso2carbon" > ${USER_HOME}/ciphertool-password
fi
if [ ! -f ${USER_HOME}/admin-password ]; then
  echo "admin" > ${USER_HOME}/admin-password
fi


# --- POPULATE PERSISTENT STORAGE ---
if [ -d "${USER_HOME}/server" ]; then
  echo "Checked control file -> ${USER_HOME}/server/OK_MOUNT.txt"
  if [ ! -f ${USER_HOME}/server/OK_MOUNT.txt ]; then
    echo "Populated the folder -> ${USER_HOME}/server"
    cp -pr ${CARBON_PATH}/repository/deployment/server/* ${USER_HOME}/server
    touch ${USER_HOME}/server/OK_MOUNT.txt
  fi

  echo "Checked new versions of the persistent storage."
  rsync -rvau ${CARBON_PATH}/repository/deployment/server/webapps ${USER_HOME}/server

  if [ -d "${USER_HOME}/server/webapps" ]; then
    echo "Checked version & unzipped new .war."
    find ${USER_HOME}/server/webapps/* -maxdepth 0 -type d ! -name "*.war" ! -name "." -exec sh -c 'if [ $(dirname "{}")/{} -nt $(dirname "{}")/{}".war" ]; then echo "{} was not update." & rm -r "{}" ; else echo "{} was update." ; fi' \;
    find ${USER_HOME}/server/webapps/* -maxdepth 1 -type f -name "*.war" -exec sh -c 'unzip -qq -n "{}" -d $(dirname "{}")/$(basename "{}" .war)' \;
  fi

  echo "Linked volume -> ${USER_HOME}/server"
  rm -rf ${CARBON_PATH}/repository/deployment/server
  ln -s ${USER_HOME}/server/ ${CARBON_PATH}/repository/deployment/server

  echo "Overwrited -> /config-server"
  test -d ${USER_HOME}/config-server && cp -RvTL ${USER_HOME}/config-server ${USER_HOME}/server
fi

# --- OVERWRITTEN CONFIG ---
echo "Overwrited -> /config"
test -d ${USER_HOME}/config && cp -RvTL ${USER_HOME}/config ${CARBON_PATH}

# --- SET CONFIG EPHEMERAL ---
MY_IP=$(hostname -i)

#echo "Setted IP -> ${CARBON_PATH}/repository/conf/axis2/axis2.xml"
#sed -i "s#<parameter\ name=\"localMemberHost\".*<\/parameter>#<parameter\ name=\"localMemberHost\">${MY_IP}<\/parameter>#" ${CARBON_PATH}/repository/conf/axis2/axis2.xml

CIPHERTOOL_PASSWORD=$(cat ${USER_HOME}/ciphertool-password)
ADMIN_PASSWORD=$(cat ${USER_HOME}/admin-password)
if [ "${CIPHERTOOL}" = "true" ]; then
  echo "Executed ciphertool.sh ..."
  if [ -f "${CARBON_PATH}/repository/conf/security/cipher-text.properties" ]; then
    sed -i "s#UserManager.AdminUser.Password=\[admin\]#UserManager.AdminUser.Password=\[${ADMIN_PASSWORD}\]#" ${CARBON_PATH}/repository/conf/security/cipher-text.properties
  fi
  if [ -f "${CARBON_PATH}/repository/conf/jndi.properties" ]; then
    echo "Changed password for jndi -> ${CARBON_PATH}/repository/conf/jndi.properties"
    sed -i "s#admin:admin@#admin:${ADMIN_PASSWORD}@#" ${CARBON_PATH}/repository/conf/jndi.properties
  fi
  sh ${CARBON_PATH}/bin/${CIPHERTOOL_SCRIPT} "-Dconfigure -Dpassword=${CIPHERTOOL_PASSWORD}"
  echo ${CIPHERTOOL_PASSWORD} > ${CARBON_PATH}/password-persist
else
  echo "Changed password for user manager -> ${CARBON_PATH}/repository/conf/user-mgt.xml"
  sed -i "s#<Password>admin</Password>#<Password>${ADMIN_PASSWORD}</Password>#" ${CARBON_PATH}/repository/conf/user-mgt.xml
  if [ -f "${CARBON_PATH}/repository/conf/jndi.properties" ]; then
    echo "Changed password for jndi -> ${CARBON_PATH}/repository/conf/jndi.properties"
    sed -i "s#admin:admin@#admin:${ADMIN_PASSWORD}@#" ${CARBON_PATH}/repository/conf/jndi.properties
  fi
fi

echo "Validated xml files -> ${CARBON_PATH}/repository/conf/"
find ${CARBON_PATH}/repository/conf/ -iname "*.xml" | xargs xmllint --noout

# --- LOAD PUBLIC CERTIFICATE ---
if [ ! -z "${LIST_PUBLIC_CERTIFICATES}" ]; then
  OLD_IFS="${IFS}"
  IFS='|'
  set -- ${LIST_PUBLIC_CERTIFICATES}
  for url in "$@"; do
    echo "Loaded certificate url $url."
    keytool -printcert -sslserver $url -rfc > tempfile
    TRUSTSTORE=${CARBON_PATH}/repository/resources/security/client-truststore.jks
    keytool -import -noprompt -alias $url -keystore ${TRUSTSTORE} -storepass wso2carbon -storetype jks < tempfile
    rm tempfile
  done
  IFS="${OLD_IFS}"
fi

#echo "Applied K8S configuration..."
#sh ${USER_HOME}/resources/scripts/k8s.sh ${CARBON_PATH}/repository/components/lib

echo "Applied DBMS configuration..."
sh ${USER_HOME}/resources/scripts/dbms.sh ${CARBON_PATH}/repository/components/lib

#echo "Applied OPEN TRACING configuration..."
#sh ${USER_HOME}/resources/scripts/opentracing.sh ${CARBON_PATH}/repository/components/dropins

#echo "Applied JVM MONITORING configuration..."
#source ${USER_HOME}/resources/scripts/jvmmonitoring.sh ${USER_HOME}/jvmmonitoring
mkdir ${CARBON_PATH}/tmp
echo "Starting server... with running ${CARBON_PROFILE} profile..."
sh ${CARBON_PATH}/bin/${CARBON_SCRIPT} "$@"
