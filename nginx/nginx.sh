#!/bin/bash

VERSION=$(cat ./VERSION)
DASH=$(cat ./GET_DASH)
START_RESTART="service nginx restart"

# If command line is UPGRADE RUN ....  or UPGRADE -option=... then pull down the latest build of valet.
if [[ $1 == "UPGRADE" ]]; then
    shift;
    wget $DASH
    chmod a+x dash && sudo cp dash /usr/local/bin
fi

if [[ $1 == "RUN" ]]; then
    shift;
    CMD=$@
    echo "Executing command: [ $CMD ]"
    $CMD
else
    OPTIONS=$@
    echo "Entrypoint with options: [ $OPTIONS ]"
    dash -version=$VERSION -service=nginx -daemon -no_source_env -logtostderr $OPTIONS exec $START_RESTART
fi
