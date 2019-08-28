#!/bin/bash

# ２重起動防止
if [ $(pgrep loop.sh) ] ; then
  exit 0
fi

cp -f /home/pi/git/LinuxKaraoke/all_nightly.csv /home/pi/git/LinuxKaraoke/all.csv 
sudo /home/pi/git/LinuxKaraoke/loop.sh