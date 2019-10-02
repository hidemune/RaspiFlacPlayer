#!/bin/bash

MusicDir=$(cat MusicDir)

  fname="$1"
  base=$(basename "$1")

  text="$(ffprobe "$1" 2>&1 1>/dev/null)"
  echo "$text"
  tracknumber="    "$(echo "$text" | grep -m 1 -i " track " | awk '{ sub("[^.]* : ",""); print $0; }')
  num=$(echo ${tracknumber} | rev | cut -c 1-3 | rev)

  artist=$(echo "$text" | grep -m 1 -i " artist " | awk '{ sub("[^.]* : ",""); print $0; }')
  album=$(echo "$text" | grep -m 1 -i " album " | awk '{ sub("[^.]* : ",""); print $0; }')
  title=$(echo "$text" | grep -m 1 -i " title " | awk '{ sub("[^.]* : ",""); print $0; }')

  if [ "${artist}" == "" ]; then
    artist="-"
  fi
  if [ "${album}" == "" ]; then
    album="-"
  fi
  if [ "${title}" == "" ]; then
    title="$1"
  fi
  
function urlencode {
  #echo "$1" | nkf -WwMQ | sed 's/=$//g' | tr = % | tr -d '\n'
  echo "$1" | nkf -WwMQ | sed 's/=$//g' | tr = % | tr -d '\n'
}

artist=$(echo "$artist" | xargs | cut -f 1 -d ' ')
query=$(urlencode "$title")

get=$(wget -q -O - "https://www.uta-net.com/search/?Aselect=2&Bselect=3&Keyword=${query}")
hitsongs=$(echo $get | egrep -o "/song/.{1,9}/" | wc -l)
#echo Count : ${hitsongs}
if [ ${hitsongs} -eq 0 ] ; then
  :
  songid=""
  firefox "https://search.yahoo.co.jp/search?p=${query}+歌詞&ei=UTF-8" &
  exit 0
else
  songid=$(echo "$get" | grep "${artist}" | egrep -om1 "/song/.{1,9}/" )
fi
#echo SongID : $songid
if [ "$songid" != "" ];then
  #echo Songid : $songid
  #ret=$(wget -q -O - "https://www.uta-net.com${songid}" | grep '<div id="kashi_area" itemprop="text">' | sed -e 's/<div id="kashi_area" itemprop="text">//g' -e 's/<\/div>//g' -e 's/<br \/>/\n/g' | sed 's/^\s*//g')
  #echo "$ret"
  #if [ "$ret" != "" ]; then
  #  sudo mkdir -p "${MusicDir}/playerSetting/$1"
  #  sudo chmod 777 "${MusicDir}/playerSetting/$1"
  #  sudo echo "$ret" >> "${file}"
  #fi
  firefox "https://www.uta-net.com${songid}" &
else
  firefox "https://www.uta-net.com/search/?Aselect=2&Bselect=3&Keyword=${query}" &
fi