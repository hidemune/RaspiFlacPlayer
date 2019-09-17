#!/bin/bash

sudo ifdown eth0 --force
sudo ifup eth0

for i in [ 1..30 ]; do
  ip2=`hostname -I | awk '{print $1}'`
  if [[ "$ip2" == 192* ]]; then
    break
  fi
  sleep 1
done

rm -f /var/lib/tomcat8/webapps/ROOT/start
cd /home/pi/git/RaspiFlacPlayer/

#ip2=`hostname -I | awk '{print $1}'`

if [[ "${ip2}" != 192* ]]; then
  echo ネットワークアドレスを取得できません。
  echo WiFiまたはLANケーブルをご確認ください。
  echo "LANケーブルが接続されていないため、ネットワーク機能は利用できません。" > url.txt
  open_jtalk -x /var/lib/mecab/dic/open-jtalk/naist-jdic -m /usr/share/hts-voice/nitech-jp-atr503-m001/nitech_jp_atr503_m001.htsvoice -r 1.0 -ow url.wav url.txt
else
  #url="http://${ip2}:8080"
  url="http://${ip2}"
  echo 以下のアドレスに、LAN経由で繋いでください。
  echo
  echo ${url}

  sudo cp -f all.csv /var/lib/tomcat8/webapps/ROOT/

  qrencode -t ansi "${url}"
  aplay /home/pi/git/ready.wav 2>/dev/null

  #touch /var/lib/tomcat8/webapps/ROOT/start

  echo "以下のアドレスに、LAN経由で繋いでください。 ${url}" | sed -e "s/\./ ドット /g" -e "s/http\:\/\// /g" -e "s/\//スラッシュ /g" -e "s/:8080//g" > url.txt
  open_jtalk -x /var/lib/mecab/dic/open-jtalk/naist-jdic -m /usr/share/hts-voice/nitech-jp-atr503-m001/nitech_jp_atr503_m001.htsvoice -r 1.0 -ow url.wav url.txt
fi

while [ 1 ]; do
  if [ -f /var/lib/tomcat8/webapps/ROOT/start ]; then
    xte 'keydown Alt_L' 
    xte 'key " "'
    xte 'keyup Alt_L'
    xte 'key N'

    sudo /home/pi/git/RaspiFlacPlayer/startNightly.sh
    sudo cp -f /var/lib/tomcat8/webapps/ROOT/rireki /home/pi/git/RaspiFlacPlayer/rireki

    sudo umount /home/pi/mount
    sleep 3
    sudo shutdown now
    exit 0
  else
    aplay url.wav 2>/dev/null
    touch /var/lib/tomcat8/webapps/ROOT/start
  fi
  sleep 1
done
