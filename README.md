rancher-tools
=============

A base image to expose tools to services. It's based in alpine-tools, adding confd and monit scripts to the image.

##Build

```
docker build -t <repo>/rancher-tools:<version> .
```

## Tools volume

This images creates a volume /opt/tools and permits share tools with the services, avoiding coupling service with configuration.

That volume has the following structure:

```
|- /opt/tools
|-|- confd 	# Confd directory
|-|-|- etc
|-|-|-|- templates
|-|-|-|- conf.d
|-|-|- bin/service-conf.sh          # Confd script to start stop or restart confd with rancher config
|-|- monit/conf.d/monit-conf.cfg  	# Confd start script for monit
```


## Versions

- `0.3.3` [(Dockerfile)](https://github.com/rawmind0/rancher-tools/blob/master/Dockerfile)

## Usage

To use this image include `FROM rawmind/rancher-tools` at the top of your `Dockerfile`, add templates and conf.d files from your service.

Starting from `rawmind/rancher-tools` provides you with the ability to easily get dinamic configuration using confd. confd will also keep running checking for config changes, restarting your service.

This image has to be started once as a sidekick of your service (based in alpine-monit), exporting a /opt/tools volume to it. It adds monit conf.d to start confd with a default parameters, that you can overwrite with environment variables.


## Examples

An example of using this image can be found in the [rawmind/alpine-zk][alpine-zk].

[confd]: http://www.confd.io/
