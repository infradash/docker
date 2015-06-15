# Mqtt

# Pull base image.
FROM ubuntu:14.04

WORKDIR /home/mosquitto

####################################
COPY VERSION .
COPY MANIFEST .
COPY DASH_* ./
COPY *.sh dash /usr/local/bin/
####################################

RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install build-essential libssl-dev uuid-dev wget libc-ares-dev

RUN wget http://mosquitto.org/files/source/mosquitto-1.4.2.tar.gz
RUN tar xvfz mosquitto-1.4.2.tar.gz && cd mosquitto-1.4.2 && make install
RUN /sbin/ldconfig

RUN useradd -d /home/mosquitto -m mosquitto

EXPOSE 1883

ENTRYPOINT [ "mqtt.sh" ]
