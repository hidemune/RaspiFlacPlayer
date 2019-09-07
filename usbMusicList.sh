#!/bin/bash

cd /home/pi/git/RaspiFlacPlayer/

DEVICE=sda1

sudo umount /dev/${DEVICE} 
sudo mount -o iocharset=utf8 /dev/${DEVICE} /home/pi/mount/ || sudo mount /dev/${DEVICE} /home/pi/mount/

if [ $? -gt 0 ] ; then
  echo No USB...
  find /home/pi/Music/ -type f | sort > work.txt

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

# USB動作モード

lsblk -n -o NAME,MOUNTPOINT

sudo cp -f $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/bkup.txt ./bkup.txt
sudo cp -f $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/*.csv ./
find $(lsblk -n -o MOUNTPOINT /dev/${DEVICE}) -type d -name playerSetting -prune -o -type f | sort > work.txt

if diff -q work.txt bkup.txt >/dev/null ; then
  sudo ./getIP_Nightly.sh
else
  # Diff!
  sudo cp -f work.txt bkup.txt
  sudo mkdir $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/
  ./makeCSV.sh $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})
  sudo cp -f *.csv $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/
  sudo cp -f bkup.txt $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/bkup.txt
  sudo ./getIP_Nightly.sh
  sudo umount $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})
fi
