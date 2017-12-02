FROM rawmind/alpine-tools:3.6-1
MAINTAINER Raul Sanchez <rawmind@gmail.com>

ENV SERVICE_ARCHIVE=/opt/rancher-tools.tgz \
    GOMAXPROCS=2 \
    GOROOT=/usr/lib/go \
    GOPATH=/opt/src \
    GOBIN=/gopath/bin \
    RANCHER_METADATA_VERSION=0.2 \
    RANCHER_METADATA_REPO=https://github.com/rawmind0/rancher-metadata.git

# Add files
ADD root /
RUN apk add --no-cache go git musl-dev && \
    mkdir -p /opt/src \
      ${SERVICE_VOLUME}/rancher-template/etc \
      ${SERVICE_VOLUME}/rancher-template/bin \
      ${SERVICE_VOLUME}/rancher-template/tmpl && \
    cd /opt/src && \
    git clone -b ${RANCHER_METADATA_VERSION} ${RANCHER_METADATA_REPO} && \
    cd rancher-metadata && \
    go get && \
    CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o rancher-template && \
    chmod 755 rancher-template && \
    mv rancher-template ${SERVICE_VOLUME}/rancher-template/bin/ && \
    cd ${SERVICE_VOLUME} && \
    tar czvf ${SERVICE_ARCHIVE} * && \
    apk del go git musl-dev && \
    rm -rf /var/cache/apk/* /opt/src ${SERVICE_VOLUME}/* 


    