#!/bin/bash
touch /var/lib/tomcat8/webapps/ROOT/stop
while sudo killall play; do
    sleep 1
done
while sudo killall cvlc; do
    sleep 1
done
#killall random.sh
#killall omxplayer.sh
#killall loop.sh
rm /var/lib/tomcat8/webapps/ROOT/que*
