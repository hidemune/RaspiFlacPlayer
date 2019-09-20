#!/bin/bash
function urlencode {
  #echo "$1" | nkf -WwMQ | sed 's/=$//g' | tr = % | tr -d '\n'
  echo "$1" | nkf -WwMQ | sed 's/=$//g' | tr = % | tr -d '\n'
}
artist="$1"
query=$(urlencode "$2")

file=${MusicDir}/playerSetting/$1/$2.txt
if [ -e "${file}" ]; then
  cat "${file}"
  exit 0
fi

get=$(wget -q -O - "https://www.uta-net.com/search/?Aselect=2&Bselect=&Keyword=${query}")
hitsongs=$(echo $get | egrep -o "/song/.{1,9}/" | wc -l)
#echo Count : ${hitsongs}
if [ ${hitsongs} -eq 0 ] ; then
  :
  songid=""
else
  songid=$(echo "$get" | grep "${artist}" | egrep -om1 "/song/.{1,9}/" )
fi
#echo SongID : $songid
if [ "$songid" != "" ];then
  #echo Songid : $songid
  ret=$(wget -q -O - "https://www.uta-net.com${songid}" | grep '<div id="kashi_area" itemprop="text">' | sed -e 's/<div id="kashi_area" itemprop="text">//g' -e 's/<\/div>//g' -e 's/<br \/>/\n/g' | sed 's/^\s*//g')
  echo "$ret"
  if [ "$ret" != "" ]; then
    sudo mkdir "${MusicDir}/playerSetting/$1"
    sudo chmod 777 "${MusicDir}/playerSetting/$1"
    sudo echo "$ret" >> "${file}"
  fi
fi
