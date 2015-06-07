# Haproxy
# See https://github.com/haproxyinc/docker-haproxy/blob/master/Dockerfile

# Pull base image.
FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y wget make gcc binutils libssl-dev libffi-dev bash

WORKDIR /root

RUN wget http://www.haproxy.org/download/1.5/src/haproxy-1.5.1.tar.gz
RUN tar -zxvf haproxy-1.5.1.tar.gz
RUN cd haproxy-1.5.1 && make TARGET=generic && make install
RUN touch /var/run/haproxy.pid

ADD valet /usr/local/bin/
ADD haproxy.sh /usr/local/bin/
ADD VERSION /etc/haproxy/
ADD MANIFEST /etc/haproxy/
ADD haproxy.cfg /etc/haproxy/

EXPOSE 1936
VOLUME ["/var/run/", "/etc/haproxy/", "/var/run", "/var/log" ]

WORKDIR /etc/haproxy/

ENTRYPOINT [ "haproxy.sh" ]
