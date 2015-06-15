# Nginx
# See https://github.com/nginxinc/docker-nginx/blob/master/Dockerfile

# Pull base image.
FROM ubuntu:14.04

WORKDIR .

####################################
COPY VERSION .
COPY MANIFEST .
COPY DASH_* .
COPY *.sh dash /usr/local/bin/
####################################

RUN mkdir -p /etc/nginx/html/
COPY error.html /etc/nginx/html/


####################################

RUN sudo apt-get install -y wget

# Install Nginx 1.8 (stable)
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update -y 
RUN apt-get install -y nginx

# forward request and error logs to docker log collector
#RUN ln -sf /dev/stdout /var/log/nginx/access.log
#RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/var/cache/nginx", "/var/log/nginx", "/var/run", "/etc/nginx" ]

# Copy the config
COPY nginx.conf /etc/nginx/sites-enabled/default

EXPOSE 80 443 25658

ENTRYPOINT [ "nginx.sh" ]
