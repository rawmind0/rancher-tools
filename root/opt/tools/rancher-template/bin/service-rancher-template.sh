#!/usr/bin/env bash

set -e

function log {
        echo `date` $ME - $@ 
}

function checkNetwork {
    log "[ Checking container ip... ]"
    a="`ip a s dev eth0 &> /dev/null; echo $?`"
    while  [ $a -eq 1 ];
    do
        a="`ip a s dev eth0 &> /dev/null; echo $?`" 
        sleep 1
    done

    log "[ Checking container connectivity... ]"
    b="`fping -c 1 rancher-metadata.rancher.internal &> /dev/null; echo $?`"
    while [ $b -eq 1 ]; 
    do
        b="`fping -c 1 rancher-metadata.rancher.internal &> /dev/null; echo $?`"
        sleep 1 
    done
}

function serviceStart {
    checkNetwork
    log "[ Starting ${CONF_NAME}... ]"
    /usr/bin/nohup ${CONF_BIN} &
    echo $! > ${CONF_HOME}/${CONF_NAME}.pid
}

function serviceStop {
    log "[ Stoping ${CONF_NAME}... ]"
    kill `cat ${CONF_HOME}/${CONF_NAME}.pid`
}

function serviceRestart {
    log "[ Restarting ${CONF_NAME}... ]"
    serviceStop 
    serviceStart
    /opt/monit/bin/monit reload
}

CONF_NAME=rancher-template
CONF_HOME=${CONF_HOME:-"/opt/tools/rancher-template"}
CONF_BIN=${CONF_BIN:-"${CONF_HOME}/rancher-template"}

case "$1" in
        "start")
            serviceStart >> ${CONF_LOG} 2>&1
        ;;
        "stop")
            serviceStop >> ${CONF_LOG} 2>&1
        ;;
        "restart")
            serviceRestart >> ${CONF_LOG} 2>&1
        ;;
        *) echo "Usage: $0 restart|start|stop"
        ;;

esac
