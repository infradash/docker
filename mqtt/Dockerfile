# Mqtt

# Pull base image.
FROM ubuntu:14.04

WORKDIR . 

####################################
ADD VERSION .
ADD MANIFEST .
ADD DASH_AUTH_TOKEN .
ADD DASH_BINARY .
ADD DASH_CMD .
ADD DASH_OPTIONS .
ADD dash /usr/local/bin/
ADD mqtt.sh /usr/local/bin/
####################################


RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install build-essential libssl-dev uuid-dev wget libc-ares-dev

RUN wget http://mosquitto.org/files/source/mosquitto-1.4.2.tar.gz
RUN tar xvfz mosquitto-1.4.2.tar.gz && cd mosquitto-1.4.2 && make install
RUN /sbin/ldconfig

#RUN useradd -d /home/mosquitto -m mosquitto
#WORKDIR /home/mosquitto

EXPOSE 1883

ENTRYPOINT [ "mqtt.sh" ]
