#!/bin/bash

##############################################################
#
# Template for Docker image ENTRYPOINT
#
export PATH=$PWD:$PATH

: ${DASH_BINARY:=$(cat ./GET_DASH)}
# If command line is UPGRADE RUN ....  or UPGRADE -option=... then pull down the latest build of valet.
if [[ $1 == "UPGRADE" ]]; then
    shift;
     wget ${DASH_BINARY}
     chmod a+x dash
fi

: ${DASH_OPTIONS:="-daemon -no_source_env -logtostderr"}
: ${DASH_CONFIG_URL:=""}
: ${DASH_AUTH_TOKEN:=""}
: ${DASH_CMD:=$(cat ./DASH_CMD)}

##############################################################
: ${DASH_DOMAIN:=""}
: ${DASH_VERSION:=$(cat ./VERSION)}
: ${DASH_SERVICE:=$(echo $0 | sed -e 's/.sh//g' -e 's/.\///g')}
: ${DASH_PATH:=""}

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
