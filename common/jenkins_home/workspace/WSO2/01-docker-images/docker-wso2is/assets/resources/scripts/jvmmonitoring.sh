#!/bin/sh

set -e

if [ "${JVM_MONITORING_ENABLED}" = "true" ]; then
  echo "JVM MONITORING enabled."    
  export JAVA_OPTS=$JAVA_OPTS" -javaagent:${USER_HOME}/resources/libs/zabbix-java-agent-1.1.0-SNAPSHOT.jar=$1/config/zabbix_agentd_jvm.conf"
else
  echo "JVM MONITORING disabled."
fi