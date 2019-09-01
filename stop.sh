#!/bin/bash

cp -f /var/lib/tomcat8/webapps/ROOT/rireki /home/pi/git/RaspiFlacPlayer/rireki

touch /var/lib/tomcat8/webapps/ROOT/stop
sudo kill -9 `pgrep play`
sudo kill -9 `pgrep vlc`

rm /var/lib/tomcat8/webapps/ROOT/que*
