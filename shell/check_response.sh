#!/bin/bash
HOSTNAME=$1
[ -z $HOSTNAME ] && echo "Gimme hostname" && exit

curl -L -w "%{http_code}" -HHost:$HOSTNAME http://`ifconfig | grep "inet addr:" | head -n 1 | awk -F : '{print $2}' | cut -d' ' -f1`
