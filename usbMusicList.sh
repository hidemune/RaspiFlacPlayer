#!/bin/bash

cd /home/pi/git/RaspiFlacPlayer/

DEVICE=sda1

sudo umount /dev/${DEVICE} 
sudo mount -o iocharset=utf8 /dev/${DEVICE} /home/pi/mount/

if [ $? -gt 0 ] ; then
  echo No USB...
  find /home/pi/Videos/ -type f | sort > work.txt

  if diff -q work.txt bkup.txt >/dev/null ; then
    sudo ./getIP_Nightly.sh
  else
    # Diff!
    sudo cp -f work.txt bkup.txt
    ./makeCSV.sh /home/pi/Music/
    sudo ./getIP_Nightly.sh
  fi

  sudo ./getIP_Nightly.sh
  exit 0
fi

lsblk -n -o NAME,MOUNTPOINT

find $(lsblk -n -o MOUNTPOINT /dev/${DEVICE}) -type f | sort > work.txt

if diff -q work.txt bkup.txt >/dev/null ; then
  sudo ./getIP_Nightly.sh
else
  # Diff!
  sudo cp -f work.txt bkup.txt
  ./makeCSV.sh $(lsblk -n -o MOUNTPOINT /dev/sda1)
  sudo ./getIP_Nightly.sh
  sudo umount $(lsblk -n -o MOUNTPOINT /dev/sda1)
fi
