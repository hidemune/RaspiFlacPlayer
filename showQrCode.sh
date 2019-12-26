#!/bin/bash

cd /home/pi/
bash start-ap-management-wifi.sh

rm -f /var/lib/tomcat8/webapps/ROOT/start

str=`ifconfig | grep "inet 192"`
ip=$(echo "$str" | awk '{print $2}')

if [ "${ip}" == "" ]; then
  echo WiFi設定を、必要に応じて行ってください。
  echo WiFi設定画面を閉じてから、Enter キーで、先に進みます。
#  sudo wicd-client &
#  read a
  sleep 60
fi

str2=`ifconfig | grep "inet 192"`
ip2=$(echo "$str2" | awk '{print $2}' | sed -n 1P)

if [ "${ip2}" == "" ]; then
  echo ネットワークアドレスを取得できません。
  echo WiFiまたはLANケーブルをご確認ください。
  read a
  exit 1
fi

url="http://${ip2}:8080"
echo 以下のアドレスに、LAN経由で繋いでください。
echo ${url}

qrencode -t ansi "${url}"
read a
