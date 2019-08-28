#!/bin/bash

# ２重起動防止
if [ $(pgrep loop.sh) ] ; then
  exit 0
fi

cp -f /home/pi/git/RaspiFlacPlayer/all_dayly.csv /home/pi/git/RaspiFlacPlayer/all.csv 
sudo /home/pi/git/RaspiFlacPlayer/loop.sh