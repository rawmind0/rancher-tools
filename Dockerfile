FROM rawmind/alpine-tools:0.3.4-7
MAINTAINER Raul Sanchez <rawmind@gmail.com>

ENV SERVICE_ARCHIVE=/opt/rancher-tools.tgz 

# Add files
ADD root /
RUN cd ${SERVICE_VOLUME} && \
    tar czvf ${SERVICE_ARCHIVE} * ; rm -rf ${SERVICE_VOLUME}/* 

