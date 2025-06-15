#!/bin/sh

set -e

if [ "${KUBERNETES_MEMBERSHIP_SCHEME}" = "true" ]; then
  if [ "${KUBERNETES_MEMBERSHIP_SCHEME_URL}" != "" ]; then
    echo "Enabled kubernetes membership scheme (${KUBERNETES_MEMBERSHIP_SCHEME_URL})."
    curl -sL "${KUBERNETES_MEMBERSHIP_SCHEME_URL}" -o $1
  else
    echo "Enabled kubernetes membership scheme (kubernetes-membership-scheme-1.0.6.jar)."
    cp -v ${USER_HOME}/resources/libs/kubernetes-membership-scheme-1.0.6.jar $1
    cp -v ${USER_HOME}/resources/libs/jackson-annotations-2.5.4.jar $1
    cp -v ${USER_HOME}/resources/libs/jackson-core-2.5.4.jar $1
    cp -v ${USER_HOME}/resources/libs/jackson-databind-2.5.4.jar $1
  fi
fi

if [ "${DNS_JAVA}" = "true" ]; then
  if [ "${DNS_JAVA_URL}" != "" ]; then
    echo "Enabled dns java (${DNS_JAVA_URL})."
    curl -sL "${DNS_JAVA_URL}" -o $1
  else
    echo "Enabled dns java (dnsjava-2.1.8.jar)."
    cp -v ${USER_HOME}/resources/libs/dnsjava-2.1.8.jar $1
  fi
fi
