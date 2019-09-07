#!/bin/bash

cd /home/pi/
bash start-ap-management-wifi.sh
sleep 10

rm -f /var/lib/tomcat8/webapps/ROOT/start
cd /home/pi/git/RaspiFlacPlayer/

while [ 1 ]; do
  ip=`hostname -I | awk '{print $1}'`

  if [[ "${ip}" == 192* ]]; then
    :
    break
  else
    echo WiFi設定を、必要に応じて行ってください。
    echo WiFi設定画面を閉じてから、Enter キーで、先に進みます。
  #  sudo wicd-client &
  #  read a
    sleep 5
  fi
done

ip2=`hostname -I | awk '{print $1}'`

if [[ "${ip2}" == 192* ]]; then
  :
else
  echo ネットワークアドレスを取得できません。
  echo WiFiまたはLANケーブルをご確認ください。
  read a
  exit 1
fi

url="http://${ip2}:8080"
echo 以下のアドレスに、LAN経由で繋いでください。
echo
echo ${url}

qrencode -t ansi "${url}"
aplay /home/pi/git/ready.wav

#touch /var/lib/tomcat8/webapps/ROOT/start

echo "${url}" | sed -e "s/\./ ドット /g" -e "s/\:/ コロン /g" -e "s/\//スラッシュ /g" -e "s/8080/8丸8丸 /g" > url.txt
open_jtalk -x /var/lib/mecab/dic/open-jtalk/naist-jdic -m /usr/share/hts-voice/nitech-jp-atr503-m001/nitech_jp_atr503_m001.htsvoice -r 1.0 -ow url.wav url.txt

while [ 1 ]; do
  if [ -f /var/lib/tomcat8/webapps/ROOT/start ]; then
    xte 'keydown Alt_L' 
    xte 'key Space'
    xte 'keyup Alt_L'
    xte 'key N'

    sudo /home/pi/git/RaspiFlacPlayer/startNightly.sh
    sudo cp -f /var/lib/tomcat8/webapps/ROOT/rireki /home/pi/git/RaspiFlacPlayer/rireki

    sudo umount /home/pi/mount
    sleep 3
    sudo shutdown now
    exit 0
  else
    aplay url.wav
  fi
  sleep 1
done
