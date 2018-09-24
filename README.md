rancher-tools
=============

A base image to expose tools to services. It's based in [rawmind/alpine-tools][alpine-tools], adding rancher-template and monit scripts to the image.

##Build

```
docker build -t rancher-tools/rancher-tools:<version> .
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
|-|- rancher-metadata  # rancher metadata directory
|-|-|- etc
|-|-|- tmpl
|-|-|- bin/service-rancher-template.sh ## Rancher-metadata script to start stop or restart 
|-|- monit/conf.d/monit-rancher-template.cfg  	# Rancher-metadata start script for monit
```


## Versions

- `3.7-0` [(Dockerfile)](https://github.com/rawmind0/rancher-tools/blob/3.7-0/Dockerfile)
- `3.6-7` [(Dockerfile)](https://github.com/rawmind0/rancher-tools/blob/3.6-7/Dockerfile)
- `3.5-4` [(Dockerfile)](https://github.com/rawmind0/rancher-tools/blob/3.5-4/Dockerfile)
- `0.3.4-7` [(Dockerfile)](https://github.com/rawmind0/rancher-tools/blob/0.3.4-7/Dockerfile)

## Usage

To use this image include `FROM rawmind/rancher-tools` at the top of your `Dockerfile`, add templates and conf.d files from your service.

Starting from `rawmind/rancher-tools` provides you with the ability to easily get dinamic configuration using [rancher-template][rancher-template] by default or confd. Rancher-template will also keep running getting for config changes at near real time, restarting your service if needed.

This image has to be started once as a sidekick of your service (based in alpine-monit), exporting a /opt/tools volume to it. It adds monit conf.d to start rancher-template with a default parameters, that you can overwrite with environment variables.

## Default parameters

Default parameters to run [rancher-template][rancher-template] at repo. You could overwrite these values, setting environment variables.

- CONF_NAME=rancher-template
- CONF_HOME=${CONF_HOME:-"/opt/tools/rancher-template"}
- CONF_BIN=${CONF_BIN:-"${CONF_HOME}/rancher-template"}


## Examples

An example of using this image can be found in the [rawmind/rancher-traefik][rancher-traefik].

[rancher-traefik]: https://github.com/rawmind0/rancher-traefik
[alpine-tools]: https://github.com/rawmind0/alpine-tools
[rancher-template]: https://github.com/rawmind0/rancher-template

