#!/bin/bash

VERSION=$(cat ./VERSION)
SERVICE=${SERVICE:-`echo $0 | sed -e 's/.sh//g' -e 's/.\///g'`}
START_RESTART="/usr/local/sbin/haproxy -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid -sf $(cat /var/run/haproxy.pid)"

# If command line is UPGRADE RUN ....  or UPGRADE -option=... then pull down the latest build of valet.
if [[ $1 == "UPGRADE" ]]; then
    shift;
    wget http://blinkergit.github.io/ops-release/build/valet/latest/bin/valet
    chmod a+x valet && sudo cp valet /usr/local/bin
fi

if [[ $1 == "RUN" ]]; then
    shift;
    CMD=$@
    echo "$SERVICE: Executing command: [ $CMD ]"
    $CMD
else
    OPTIONS=$@
    echo "$SERVICE with options: [ $OPTIONS ]"
    valet -version=$VERSION -service=$SERVICE -daemon -no_source_env -logtostderr $OPTIONS exec $START_RESTART
fi
