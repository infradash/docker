# Builder

# Pull base image.
FROM ubuntu:14.04

WORKDIR .

####################################
RUN mkdir -p /etc/dash/
COPY MANIFEST /etc/dash/
COPY DASH_* /etc/dash/
COPY dash /usr/local/bin/
COPY *.sh /usr/local/bin/
####################################

RUN apt-get update
RUN apt-get install -y software-properties-common git-core wget make sshfs


###########
RUN mkdir -p /var/build
WORKDIR /var/build

# Expose volumes.  This allows us to use the image as data containers as well
VOLUME /var/build
VOLUME /var/log

EXPOSE 25658
ENTRYPOINT ["builder.sh"]
