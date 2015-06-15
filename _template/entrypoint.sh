#!/bin/bash

##############################################################
#
# Template for Docker image ENTRYPOINT
#

: ${DASH_CMD:=$(cat /etc/dash/DASH_CMD)}  # Cmd to fork and execute
: ${DASH_BINARY:=$(cat /etc/dash/DASH_BINARY)} # Dash binary url
: ${DASH_OPTIONS:=$(cat /etc/dash/DASH_OPTIONS)}
: ${DASH_AUTH_TOKEN:=$(cat /etc/dash/DASH_AUTH_TOKEN)}
: ${DASH_VERSION:=$(cat /etc/dash/DASH_VERSION)}

: ${DASH_CONFIG_URL:=""}
: ${DASH_DOMAIN:=""}
: ${DASH_SERVICE:=$(echo $0 | sed -e 's/.sh//g' -e 's/.\///g')}
: ${DASH_PATH:=""}

# If command line is UPGRADE RUN ....  or UPGRADE -option=... then pull down the latest build of valet.
if [[ $1 == "UPGRADE" ]]; then
    shift;
     wget ${DASH_BINARY}
     chmod a+x dash
     export PATH=$PWD:$PATH
fi

##############################################################

case $1 in
RUN)
    shift;
    CMD=$@
    echo "RUN [ $CMD ]"
    $CMD
;;

*)
    echo "${DASH_SERVICE} args: $@"
    exec="dash ${DASH_OPTIONS} -domain=${DASH_DOMAIN} -service=${DASH_SERVICE} -version=${DASH_VERSION} -path=${DASH_PATH} -config_url=${DASH_CONFIG_URL} exec ${DASH_CMD} $@"
    echo $exec
    $exec
;;
esac
