# Mqtt

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

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install build-essential libssl-dev uuid-dev wget libc-ares-dev

RUN wget http://mosquitto.org/files/source/mosquitto-1.4.2.tar.gz
RUN tar xvfz mosquitto-1.4.2.tar.gz && cd mosquitto-1.4.2 && make install
RUN /sbin/ldconfig

RUN useradd -d /home/mosquitto -m mosquitto

EXPOSE 1883 25658

ENTRYPOINT [ "mqtt.sh" ]
