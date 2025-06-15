#!/bin/sh

set -e

if [ "${OPENTRACING_ENABLED}" = "true" ]; then
  echo "OPENTRACING enabled."
  cp -v ${USER_HOME}/resources/libs/wso2-opentracing-module-1.0.1.jar $1
else
  echo "OPENTRACING disabled."
fi
