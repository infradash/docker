#!/bin/bash

VERSION=$(cat ./VERSION)
DASHER=$(cat ./GET_DASHER)
START_RESTART="service nginx restart"

# If command line is UPGRADE RUN ....  or UPGRADE -option=... then pull down the latest build of valet.
if [[ $1 == "UPGRADE" ]]; then
    shift;
    wget $DASHER
    chmod a+x dasher && sudo cp dasher /usr/local/bin
fi

if [[ $1 == "RUN" ]]; then
    shift;
    CMD=$@
    echo "Executing command: [ $CMD ]"
    $CMD
else
    OPTIONS=$@
    echo "Entrypoint with options: [ $OPTIONS ]"
    dasher -version=$VERSION -service=nginx -daemon -no_source_env -logtostderr $OPTIONS exec $START_RESTART
fi
