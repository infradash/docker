# Builder

# Pull base image.
FROM busybox

WORKDIR .

####################################
RUN mkdir -p /etc/dash/
COPY MANIFEST /etc/dash/
COPY DASH_* /etc/dash/
COPY dash /usr/local/bin/
####################################

###########
RUN mkdir -p /var/build
WORKDIR /var/build

# Expose volumes.  This allows us to use the image as data containers as well
VOLUME /var/build
VOLUME /var/log

EXPOSE 8888
ENTRYPOINT ["dash", "--logtostderr", "proxy"]
