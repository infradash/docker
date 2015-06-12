#!/bin/bash

VERSION=$(cat ./VERSION)
DASH=$(cat ./GET_DASH)
SERVICE=${SERVICE:-`echo $0 | sed -e 's/.sh//g' -e 's/.\///g'`}
START_RESTART="/usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf"
START_RESTART="service postgresql restart"

# If command line is UPGRADE RUN ....  or UPGRADE -option=... then pull down the latest build of dash.
if [[ $1 == "UPGRADE" ]]; then
    shift;
    wget $DASH
    chmod a+x dash && sudo cp dash /usr/local/bin
fi

if [[ $1 == "RUN" ]]; then
    shift;
    CMD=$@
    echo "$SERVICE: Executing command: [ $CMD ]"
    $CMD
else
    OPTIONS=$@
    echo "$SERVICE with options: [ $OPTIONS ]"
    dash -version=$VERSION -service=$SERVICE -daemon -no_source_env -logtostderr $OPTIONS exec $START_RESTART
fi
