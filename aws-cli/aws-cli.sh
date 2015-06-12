#!/bin/bash

VERSION=$(cat ./VERSION)
DASH=$(cat ./GET_DASH)

# If command line is UPGRADE RUN ....  or UPGRADE -option=... then pull down the latest build of dash.
if [[ $1 == "UPGRADE" ]]; then
    shift;
    wget $DASH
    chmod a+x dash && sudo cp dash /usr/local/bin
fi

case $1 in
SHELL)
	shift;
	CMD=$@
	echo "Executing command: [ $CMD ]"
	$CMD
;;
RUN)
	shift;
	ZK_PATH=$1; 
	SCRIPT_URL=$2; shift; shift;
	DASH_CONFIG=$@

	echo "aws-cli SOURCE: from=$SCRIPT_URL, env=$ZK_PATH"
        #
        # Environments in ZK:
        # AUTH_TOKEN = auth token to dashboard
        # AWS_ACCESS_KEY_ID
        # AWS_SECRET_ACCESS_KEY
	# AWS_DEFAULT_REGION
	dash -logtostderr -path=$ZK_PATH $DASH_CONFIG exec /bin/bash -c "curl -sSL -H 'Authorization: Bearer {{.AUTH_TOKEN}}' $SCRIPT_URL | AWS_ACCESS_KEY={{.AWS_ACCESS_KEY}} AWS_SECRET_KEY={{.AWS_SECRET_KEY}} /bin/sh" | tee /var/log/aws-cli.log
;;
EXEC)
	shift;
	ZK_PATH=$1;
	DASH_CONFIG=$2; shift; shift;
	echo "aws-cli EXEC: env=$ZK_PATH, config=$DASH_CONFIG, cmd=$@"
        #
        # Environments in ZK:
        # AUTH_TOKEN = auth token to dashboard
        # AWS_ACCESS_KEY_ID
        # AWS_SECRET_ACCESS_KEY
	# AWS_DEFAULT_REGION
	dash -logtostderr -path=$ZK_PATH $DASH_CONFIG exec $@ | tee /var/log/aws-cli.log
;;
esac
