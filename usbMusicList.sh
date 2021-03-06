#!/bin/bash

cd /home/pi/git/RaspiFlacPlayer/
./volume.sh 100
cp *.sh /run
cp decision3.wav /run
cd /run

echo "準備を開始します。" > url.txt
open_jtalk -x /var/lib/mecab/dic/open-jtalk/naist-jdic -m /usr/share/hts-voice/nitech-jp-atr503-m001/nitech_jp_atr503_m001.htsvoice -r 1.0 -ow url.wav url.txt
aplay url.wav


DEVICE=sda1

sudo umount /dev/${DEVICE} 
sudo mount -o iocharset=utf8 /dev/${DEVICE} /home/pi/mount/ || sudo mount /dev/${DEVICE} /home/pi/mount/

if [ $? -gt 0 ] ; then
  MusicDir=/home/pi/Videos/
  echo $MusicDir > MusicDir
  echo No USB...
  echo ${MusicDir}
  find ${MusicDir} -type f -not -path "*/playerSetting/*" | sort > work.txt

  if diff -q work.txt bkup.txt >/dev/null ; then
    sudo ./getIP_Nightly.sh
  else
    # Diff!
    sudo cp -f work.txt bkup.txt
    ./makeCSV.sh ${MusicDir}
    sudo ./getIP_Nightly.sh
  fi

  sudo ./getIP_Nightly.sh
  exit 0
fi

# USB動作モード

lsblk -n -o NAME,MOUNTPOINT

sudo mkdir $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/
sudo cp -f ./rireki $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/rireki_bkup
sudo cp -f $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/bkup.txt ./bkup.txt
sudo cp -f $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/rireki ./rireki
sudo cp -f $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/*.csv ./

MusicDir=$(lsblk -n -o MOUNTPOINT /dev/${DEVICE})
echo MusicDir > MusicDir
find $(lsblk -n -o MOUNTPOINT /dev/${DEVICE}) -type f -not -path "*/playerSetting/*" -not -path "*/System Volume Information/*" -not -path "*/\$RECYCLE.BIN/*"| sort > work.txt

if diff -q work.txt bkup.txt >/dev/null ; then
  # Same !!!
  sudo ./getIP_Nightly.sh
else
  # Diff!
  sudo cp -f work.txt bkup.txt
  sudo cp -f bkup.txt $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/bkup.txt
  ./makeCSV.sh $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})
  sudo cp -f all.csv $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/
  sync
  sudo ./getIP_Nightly.sh
  sudo cp -f rireki $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})/playerSetting/rireki
  sudo umount $(lsblk -n -o MOUNTPOINT /dev/${DEVICE})
fi
