# Aws-Cli

# Pull base image.
FROM ubuntu:14.04

RUN apt-get update -y

# Base
RUN apt-get install -y wget curl zip unzip python

# AWS EC2 CLI
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
RUN./awscli-bundle/install -h

ADD aws-cli.sh /usr/local/bin/

######################################
ADD VERSION .
ADD MANIFEST .
ADD GET_DASH .
ADD dash /usr/local/bin/

WORKDIR .

VOLUME [ "/var/log/" ]

ENTRYPOINT [ "aws-cli.sh" ]
