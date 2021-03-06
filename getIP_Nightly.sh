#!/bin/bash

#sudo ifdown eth0 --force
#sudo ifup eth0

xdotool mousemove 200 200

for i in [ 1..45 ]; do
  ip2=`hostname -I | awk '{print $1}'`
  if [[ "$ip2" == 192* ]]; then
    break
  fi
  sleep 1
done

rm -f /var/lib/tomcat8/webapps/ROOT/start

#ip2=`hostname -I | awk '{print $1}'`

if [[ "${ip2}" == 192* ]]; then
  #url="http://${ip2}:8080"
  url="http://${ip2}"
  echo 以下のアドレスに、LAN経由で繋いでください。
  echo
  echo ${url}

  sudo cp -f ./all.csv /var/lib/tomcat8/webapps/ROOT/

  qrencode -t ansi "${url}"
  #aplay -D pluhw:1 /home/pi/git/ready.wav 2>/dev/null
  echo "以下のアドレスに、LAN経由で繋いでください。 ${url}" | sed -e "s/\./ ドット /g" -e "s/http\:\/\// /g" -e "s/\//スラッシュ /g" -e "s/:8080//g" > url.txt
  open_jtalk -x /var/lib/mecab/dic/open-jtalk/naist-jdic -m /usr/share/hts-voice/nitech-jp-atr503-m001/nitech_jp_atr503_m001.htsvoice -r 1.0 -ow url.wav url.txt

  #touch /var/lib/tomcat8/webapps/ROOT/start
else

  echo ネットワークアドレスを取得できません。
  echo WiFiまたはLANケーブルをご確認ください。
  echo "LANケーブルが接続されていないため、ネットワーク機能は利用できません。" > url.txt
  open_jtalk -x /var/lib/mecab/dic/open-jtalk/naist-jdic -m /usr/share/hts-voice/nitech-jp-atr503-m001/nitech_jp_atr503_m001.htsvoice -r 1.0 -ow url.wav url.txt

  touch /var/lib/tomcat8/webapps/ROOT/start
fi

while [ 1 ]; do
  if [ -f /var/lib/tomcat8/webapps/ROOT/start ]; then
    wid=$(xdotool search --onlyvisible --name sudo)
    echo wid : $wid
    xdotool windowactivate $wid
    xte 'keydown Alt_L'
    xte 'key  '
    xte 'key \ '
    xte 'keyup Alt_L'
    sleep 1
    xte 'key n'

    sudo ./startNightly.sh
    sudo cp -f /var/lib/tomcat8/webapps/ROOT/rireki ./rireki

    sudo umount /home/pi/mount
    sleep 3
    sudo shutdown now
    exit 0
  else
    aplay url.wav 2>/dev/null
    #touch /var/lib/tomcat8/webapps/ROOT/start
  fi
  sleep 1
done
