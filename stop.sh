#!/bin/bash

cp -f /var/lib/tomcat8/webapps/ROOT/rireki ./rireki

touch /var/lib/tomcat8/webapps/ROOT/stop

sudo killall play
sudo kill -9 `pgrep vlc`

rm /var/lib/tomcat8/webapps/ROOT/que*
