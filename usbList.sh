#!/bin/bash

cd /home/pi/git/RaspiFlacPlayer/

find $(lsblk -n -o MOUNTPOINT /dev/sda1) | sort > work.txt

if diff -q work.txt bkup.txt >/dev/null ; then
  sudo ./getIP_Nightly.sh
else
  # Diff!
  sudo cp -f work.txt bkup.txt
  ./makeCSV.sh $(lsblk -n -o MOUNTPOINT /dev/sda1)
  sudo ./getIP_Nightly.sh
fi