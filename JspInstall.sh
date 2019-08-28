#!/bin/bash
#cd ./
sudo mkdir /var/lib/tomcat7/webapps/ROOT/karaoke/
sudo mkdir /var/lib/tomcat8/webapps/ROOT/karaoke/
sudo cp *.jsp /var/lib/tomcat7/webapps/ROOT/karaoke/
sudo cp *.jsp /var/lib/tomcat8/webapps/ROOT/karaoke/
sudo cp *.js /var/lib/tomcat7/webapps/ROOT/karaoke/
sudo cp *.js /var/lib/tomcat8/webapps/ROOT/karaoke/
sudo cp *.css /var/lib/tomcat7/webapps/ROOT/karaoke/
sudo cp *.css /var/lib/tomcat8/webapps/ROOT/karaoke/
sudo cp index.html /var/lib/tomcat7/webapps/ROOT/
sudo cp index.html /var/lib/tomcat8/webapps/ROOT/
