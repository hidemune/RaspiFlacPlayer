#!/bin/bash

cd /home/pi/
bash start-ap-management-wifi.sh

rm -f /var/lib/tomcat8/webapps/ROOT/start
cd /home/pi/git/RaspiFlacPlayer/

ip=`hostname -I | awk '{print $1}'`

if [ "${ip}" == "" ]; then
  echo WiFi設定を、必要に応じて行ってください。
  echo WiFi設定画面を閉じてから、Enter キーで、先に進みます。
#  sudo wicd-client &
#  read a
  sleep 60
fi

ip2=`hostname -I | awk '{print $1}'`

if [ "${ip2}" == "" ]; then
  echo ネットワークアドレスを取得できません。
  echo WiFiまたはLANケーブルをご確認ください。
  read a
  exit 1
fi

url="http://${ip2}:8080"
echo 以下のアドレスに、LAN経由で繋いでください。なお、アドレスはクリップボードへコピーされます。
echo Webブラウザが表示されたら、リンクをどれか選択してください。しばらく待つと、アドレスがペーストされます。
echo
echo ${url}

qrencode -t ansi "${url}"

#touch /var/lib/tomcat8/webapps/ROOT/start

while [ 1 ]; do
  if [ -f /var/lib/tomcat8/webapps/ROOT/start ]; then
    xte 'keydown Alt_L' 
    xte 'key Space'
    xte 'keyup Alt_L'
    xte 'key N'

    sudo /home/pi/git/RaspiFlacPlayer/startNightly.sh
    sudo shutdown now
    exit 0
  fi
  sleep 1
done
