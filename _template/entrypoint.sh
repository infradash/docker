#!/bin/bash

##############################################################
#
# Template for Docker image ENTRYPOINT
#

# Options for the agent
: ${DASH_CMD:=$(cat /etc/dash/DASH_CMD)}  # Cmd to fork and execute
: ${DASH_BINARY:=$(cat /etc/dash/DASH_BINARY)} # Dash binary url
: ${DASH_OPTIONS:=$(cat /etc/dash/DASH_OPTIONS)}

# Options for identity / labels
: ${DASH_NAME:=$(cat /etc/dash/DASH_NAME)}

# Options for dynamic configuration
: ${DASH_AUTH_TOKEN:=$(cat /etc/dash/DASH_AUTH_TOKEN)}
: ${DASH_CONFIG_URL:=$(cat /etc/dash/DASH_CONFIG_URL)}

# Options for task metadata
# 1. Controls where environments are loaded from.
# 2. PATH takes precedence.  If not specified, paths are derived based on domain, service, and version
: ${DASH_PATH:=$(cat /etc/dash/DASH_PATH)}
: ${DASH_DOMAIN:=$(cat /etc/dash/DASH_DOMAIN)}
: ${DASH_SERVICE:=$(echo $0 | sed -e 's/.sh//g' -e 's/.\///g')}
: ${DASH_VERSION:=$(cat /etc/dash/DASH_VERSION)}


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
    exec="dash ${DASH_OPTIONS} -name=${DASH_NAME} -domain=${DASH_DOMAIN} -service=${DASH_SERVICE} -version=${DASH_VERSION} -path=${DASH_PATH} -config_url=${DASH_CONFIG_URL} exec ${DASH_CMD} $@"
    echo $exec
    $exec
;;
esac
