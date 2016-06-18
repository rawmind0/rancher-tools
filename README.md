rancher-tools
=============

A base image to expose tools to services. It's based in [rawmind/alpine-tools][alpine-tools], adding confd and monit scripts to the image.

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
|-|-|- bin/service-conf.sh          # Confd script to start stop or restart confd with rancher config
|-|- monit/conf.d/monit-conf.cfg  	# Confd start script for monit
```


## Versions

- `0.3.3` [(Dockerfile)](https://github.com/rawmind0/rancher-tools/blob/master/Dockerfile)

## Usage

To use this image include `FROM rawmind/rancher-tools` at the top of your `Dockerfile`, add templates and conf.d files from your service.

Starting from `rawmind/rancher-tools` provides you with the ability to easily get dinamic configuration using confd. confd will also keep running checking for config changes, restarting your service.

This image has to be started once as a sidekick of your service (based in alpine-monit), exporting a /opt/tools volume to it. It adds monit conf.d to start confd with a default parameters, that you can overwrite with environment variables.

## Default parameters

These are the default parameters to run confd. You could overwrite these values, setting environment variables.

- CONF_NAME=confd
- CONF_HOME=${CONF_HOME:-"/opt/tools/confd"}
- CONF_LOG=${CONF_LOG:-"${CONF_HOME}/log/confd.log"}
- CONF_BIN=${CONF_BIN:-"${CONF_HOME}/bin/confd"}
- CONF_BACKEND=${CONF_BACKEND:-"rancher"}
- CONF_PREFIX=${CONF_PREFIX:-"/2015-12-19"}
- CONF_INTERVAL=${CONF_INTERVAL:-60}
- CONF_PARAMS=${CONF_PARAMS:-"-confdir /opt/tools/confd/etc -backend ${CONF_BACKEND} -prefix ${CONF_PREFIX}"}
- CONF_ONETIME="${CONF_BIN} -onetime ${CONF_PARAMS}"
- CONF_INTERVAL="${CONF_BIN} -interval ${CONF_INTERVAL} ${CONF_PARAMS}"


## Examples

An example of using this image can be found in the [rawmind/rancher-traefik][rancher-traefik].

[rancher-traefik]: https://github.com/rawmind0/rancher-traefik
[alpine-tools]: https://github.com/rawmind0/alpine-tools







Many thanks for explaining how the stock options work. 
I am very interested to find out more about your organization and opportunities.

Normally compensation is something we would discuss later on but I understand
your need to have a reference or starting point.

Just for your information and in total confidentiality my current income 
equals 75K EU/year gross plus my 20% bonus based on individual performance and 
company variable calculations.
This is a unique sector and last year based on my individual performance
I got a 139% bonus of that 20%. This was a good year and might not happen every
year.

Discussing compensation is important to me like anybody else but there 
are other things that are equally important. When considering new 
opportunities compensation has not been the only determining factor for me.

So far I love everything I am learning about Rancher, both technically and
as an organization and I would love to learn more so anything you can share about the 
team, organization, products, services,  and job specifics is something it would 
be greatly appreciated.

I am customer focused, business driven and love technology working in growth and 
innovation all within a modern and efficient team culture. 

I am telling you this because I want to make sure I know more about the job and 
you also know more about me so we can make sure this is going to work well for 
everyone.  

Your thoughts?
