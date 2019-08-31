#!/bin/bash

cd /home/pi/git/RaspiFlacPlayer/

DEVICE=sda1

mount /dev/${DEVICE} /home/pi/mount/

if [ $? -gt 0 ] ; then
  echo No USB...
  ./makeCSV.sh /home/pi/Videos/
  sudo ./getIP_Nightly.sh
  exit 0
fi

lsblk -n -o NAME,MOUNTPOINT

find $(lsblk -n -o MOUNTPOINT /dev/${DEVICE}) | sort > work.txt

if diff -q work.txt bkup.txt >/dev/null ; then
  sudo ./getIP_Nightly.sh
else
  # Diff!
  sudo cp -f work.txt bkup.txt
  ./makeCSV.sh $(lsblk -n -o MOUNTPOINT /dev/sda1)
  sudo ./getIP_Nightly.sh
fi