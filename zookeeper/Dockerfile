# Zookeeper

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
RUN apt-get install -y software-properties-common git-core wget

# Java
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN apt-get install oracle-java8-installer
RUN apt-get install oracle-java8-set-default

# Zookeeper
COPY install/zookeeper-3.4.6 /usr/local/zookeeper-3.4.6
RUN cd /usr/local && ln -s zookeeper-3.4.6 zookeeper

# Exhibitor
COPY install/exhibitor-1.5.1 /usr/local/exhibitor-1.5.1
RUN cd /usr/local && ln -s exhibitor-1.5.1 exhibitor

# Supervisord
RUN apt-get update && apt-get install -y supervisor

# Create directories
RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose volumes.  This allows us to use the image as data containers as well
VOLUME /usr/local/zookeeper/conf
VOLUME /var/log/zookeeper
VOLUME /var/log/supervisor
VOLUME /var/zookeeper

EXPOSE 2181 2888 3888 8080
CMD ["zookeeper.sh"]
