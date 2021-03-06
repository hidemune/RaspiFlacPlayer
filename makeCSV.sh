#!/bin/bash

douga_mode=1

if [ "$1" == "" ] ; then
  musicpath=/home/pi/Music/
else
  musicpath=$1
fi

i=0

rm -f all.csv
IFS='
'
for f in $(find ${musicpath} -type f -not -path "*/playerSetting/*" -not -path "*/System Volume Information/*" -not -path "*/\$RECYCLE.BIN/*"); do
  fname="$f"
  base=$(basename "$f")
  vol=80
  vstr=$(echo ${f%.*} | rev 2>/dev/null | cut -c 1-5 | rev 2>/dev/null)
  if [[ ${vstr} =~ ^.*\(([0-9]+)\)$ ]]; then
    vol=${BASH_REMATCH[1]}
  fi
  if [ "$douga_mode" == 0 ]; then
    text="$(ffprobe "$f" 2>&1 1>/dev/null)"
  else
    text=""
  fi
  echo "$f"
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
    title=$f
  fi

  sortkey="${artist}${album}${num}====="

  echo -e "${sortkey}${fname}\t${artist}\t${album}\t${title}\t${vol}" >> all.csv
  i=$(echo $i+1 | bc)
  if [ $(( $i % 25 )) -eq 0 ]; then
    aplay decision3.wav &
  fi
done

sort all.csv > all_dayly.csv
rm -f all.csv
while read p; do
  echo $(echo "$p" | awk '{ sub("^.*=====",""); print $0; }') >> all.csv
done <all_dayly.csv

sync
