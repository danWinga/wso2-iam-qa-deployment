FROM adoptopenjdk/openjdk8:jdk8u242-b08-alpine AS optimizer

LABEL maintainer="Chakray Support <support@chakray.com>"

ARG PRODUCT_PATH
ARG CARBON_PROFILE_OPTIMIZER_NUMBER

WORKDIR /wso2/

COPY ${PRODUCT_PATH} ${PRODUCT_PATH}

RUN apk add --update --no-cache zip unzip bash libxml2-utils \
  && rm -rf *.zip

FROM adoptopenjdk/openjdk8:jdk8u242-b08-alpine

LABEL maintainer="Chakray Support <support@chakray.com>"

ARG PRODUCT_PATH
ARG CARBON_SCRIPT
ARG CARBON_PROFILE_OPTIMIZER_NUMBER

ENV GROUP_GID 1001
ENV GROUP_NAME wso2grp
ENV USER_UID 1001
ENV USER_NAME wso2usr
ENV USER_HOME /home/${USER_NAME}
ENV CARBON_PATH ${USER_HOME}/${PRODUCT_PATH}
ENV CARBON_SCRIPT ${CARBON_SCRIPT}
ENV CARBON_PROFILE ${CARBON_PROFILE_OPTIMIZER_NUMBER}

ENV DRIVER_DBM_ORACLE false
ENV DRIVER_DBM_ORACLE_URL ""
ENV DRIVER_DBM_MYSQL false
ENV DRIVER_DBM_MYSQL_URL ""
ENV DRIVER_DBM_MSQL false
ENV DRIVER_DBM_MSQL_URL ""
ENV DRIVER_DBM_POSTGRESQL false
ENV DRIVER_DBM_POSTGRESQL_URL ""

ENV KUBERNETES_MEMBERSHIP_SCHEME false
ENV KUBERNETES_MEMBERSHIP_SCHEME_URL ""

ENV OPENTRACING_ENABLED false
ENV JVM_MONITORING_ENABLED false

ENV DNS_JAVA false
ENV DNS_JAVA_URL ""

ENV CIPHERTOOL false
ENV CIPHERTOOL_SCRIPT ciphertool.sh

ENV LIST_PUBLIC_CERTIFICATES ""

#ENV JVM_MEM_OPTS -XX:MinRAMPercentage=60.0 -XX:MaxRAMPercentage=90.0
ENV JVM_MEM_OPTS -Xms2048m -Xmx2048m -XX:MaxPermSize=1024m
ENV JAVA_OPTS -Duser.country=KE -Duser.language=en -Duser.timezone=Africa/Nairobi -Djava.util.prefs.systemRoot=${USER_HOME}/.java -Djava.util.prefs.userRoot=${USER_HOME}/.java/.userPrefs
ENV DOCKERIZE_VERSION v0.6.1

RUN addgroup -g ${GROUP_GID} -S ${GROUP_NAME} \
  && adduser -u ${USER_UID} -S ${USER_NAME} -G ${GROUP_NAME} \
  && apk add --update --no-cache curl netcat-openbsd ca-certificates wget unzip openssl libxml2-utils apache-ant rsync \
  && rm -rf /var/cache/apk/* \
  && mkdir -p ${USER_HOME}/.java/.systemPrefs \
  && mkdir -p ${USER_HOME}/.java/.userPrefs \
  && chmod -R 755 ${USER_HOME}/.java \
  && chown -R ${USER_NAME}:${GROUP_NAME} ${USER_HOME}/.java \
  && wget -q https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY --chown=wso2usr:wso2grp assets/ ${USER_HOME}/
COPY --from=optimizer --chown=wso2usr:wso2grp /wso2/ ${USER_HOME}/

USER ${USER_UID}
WORKDIR ${USER_HOME}

EXPOSE 9763 9443 9999 11111

ENTRYPOINT ["/home/wso2usr/entrypoint.sh"]
