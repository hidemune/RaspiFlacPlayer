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
