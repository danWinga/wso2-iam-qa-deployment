#!/bin/bash

# https://docs.wso2.com/display/IS550/Changing+the+hostname / OPTION 2

CARBON_HOST="*"
KEYSTORE_ALIAS=wso2carbon

DNAME="CN=$CARBON_HOST.kra.go.ke,O=Kenya Revenue Authority"
KEYSTORE_FILE=wso2carbon.jks
KEYSTORE_PASSWORD=wso2carbon
P12_FILE=wso2carbon.p12
EXTENSIONS="digitalSignature,keyEncipherment,dataEncipherment"

#echo -n "\n\nDo you want to create certificates for domain \"${DOMAIN}\"?? [y/n]: "
#read ans
#if [ "$ans" != "${ans#[Yy]}" ] ;then

keytool -genkey -noprompt -alias $KEYSTORE_ALIAS -ext KeyUsage=$EXTENSIONS -ext eku:critical=timeStamping,OCSPSigning,serverAuth,clientAuth \
    -keyalg RSA -sigalg SHA256withRSA -keysize 2048 -validity 365 -dname "$DNAME" \
    -keystore $KEYSTORE_FILE -storepass $KEYSTORE_PASSWORD -keypass $KEYSTORE_PASSWORD \
    -ext san=dns:is.$PROJECT_NAME.$DOMAIN,dns:analytics.is.$PROJECT_NAME.$DOMAIN,dns:portainer.$PROJECT_NAME.$DOMAIN,dns:traefik.$PROJECT_NAME.$DOMAIN,dns:identity-server,dns:is-analytics-worker,dns:is-analytics-dashboard,dns:nexus.cicd.kra.go.ke

keytool -export -noprompt -alias $KEYSTORE_ALIAS -file $KEYSTORE_ALIAS.crt \
    -keystore $KEYSTORE_FILE -storepass $KEYSTORE_PASSWORD -keypass $KEYSTORE_PASSWORD
cp client-truststore-complete.jks client-truststore.jks 

keytool -import -noprompt -alias $KEYSTORE_ALIAS -file $KEYSTORE_ALIAS.crt \
    -keystore client-truststore.jks -storepass wso2carbon -keypass $KEYSTORE_PASSWORD

keytool -importkeystore -srckeystore $KEYSTORE_FILE -srcstorepass wso2carbon \
    -destkeystore $P12_FILE -deststorepass wso2carbon -deststoretype PKCS12

openssl pkcs12 -in $P12_FILE -nokeys -out $KEYSTORE_ALIAS.crt -passin pass:wso2carbon -nokeys
openssl pkcs12 -in $P12_FILE -nocerts -nodes -out $KEYSTORE_ALIAS.key -passin pass:wso2carbon -nocerts

chmod 750 *.jks
mkdir -p ../stacks/wso2/configs/keystores/
cp -fr $KEYSTORE_ALIAS.key ../stacks/traefik/configs/traefik.key
cp -fr $KEYSTORE_ALIAS.crt ../stacks/traefik/configs/traefik.crt
cp -fr client-truststore.jks ../stacks/wso2/configs/keystores/
cp -fr $KEYSTORE_FILE ../stacks/wso2/configs/keystores/

rm *.p12
rm wso2carbon.*	
rm client-truststore.jks
#fi
