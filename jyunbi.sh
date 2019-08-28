#!/bin/bash
./JspInstall.sh
cp rireki /var/lib/tomcat8/webapps/ROOT/rireki
cp all.csv /var/lib/tomcat8/webapps/ROOT/all.csv
echo 70 > /var/lib/tomcat8/webapps/ROOT/volume
chmod 777 -R /var/lib/tomcat8/webapps/ROOT
chmod 777 /var/lib/tomcat8/webapps/ROOT/rireki
chown pi:tomcat7 -R /var/lib/tomcat8/webapps/ROOT
chown tomcat8:tomcat8 -R /var/lib/tomcat8/webapps/ROOT
ls -la /var/lib/tomcat8/webapps/ROOT

