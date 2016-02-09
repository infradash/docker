# Builder

# Pull base image.
FROM ubuntu:14.04

WORKDIR .

####################################
COPY dash /usr/local/bin/
####################################

###########
RUN mkdir -p /var/build
WORKDIR /var/build

# Expose volumes.  This allows us to use the image as data containers as well
VOLUME /var/build
VOLUME /var/log

EXPOSE 8888
ENTRYPOINT ["/usr/local/bin/dash", "--logtostderr", "proxy"]
