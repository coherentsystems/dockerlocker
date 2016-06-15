FROM phusion/baseimage:0.9.15

MAINTAINER JB Smith <jb.smith@ixi.systems>

RUN apt-get update
RUN /usr/bin/workaround-docker-2267
RUN ulimit -n 40960 
RUN ulimit -c unlimited
RUN apt-get install -y wget
RUN apt-get install -y git

RUN locale-gen en_US.UTF-8
RUN echo "/root" > /etc/container_environment/HOME
RUN echo "en_US.UTF-8" > /etc/container_environment/LANG
RUN echo "en_US.UTF-8" > /etc/container_environment/LANGUAGE
RUN echo "en_US.UTF-8" > /etc/container_environment/LC_ALL


RUN \
    git clone https://github.com/torch/distro.git ~/torch --recursive && \
    cd ~/torch; bash install-deps;

RUN \
    cd ~/torch; ./install.sh


ENTRYPOINT ["/bin/bash", "-lic", "th"]