#!/bin/bash

musicpath=/home/pi/Music/
rm -f all.csv
IFS='
'
for f in $(find ${musicpath} -name '*\.*'); do
  fname=$f
  text="$(ffprobe "$f" 2>&1 1>/dev/null)"
  echo "$text"
  tracknumber="    "$(echo "$text" | grep -m 1 -i " track " | awk '{ sub("^.*:",""); print $0; }')
  num=$(echo ${tracknumber} | rev | cut -c 1-3 | rev)

  artist=$(echo "$text" | grep -m 1 -i " artist " | awk '{ sub("^.*?:",""); print $0; }')
  album=$(echo "$text" | grep -m 1 -i " album " | awk '{ sub("^.*?:",""); print $0; }')
  title=$(echo "$text" | grep -m 1 -i " title " | awk '{ sub("^.*?:",""); print $0; }')

if [ "${artist}" == "" ]; then
  artist="-"
fi
if [ "${album}" == "" ]; then
  album="-"
fi
if [ "${title}" == "" ]; then
  title="-"
fi

  sortkey="${artist}${album}${num}====="

  echo -e "${sortkey}${fname}\t${artist}\t${album}\t${title}\t70" >> all.csv
done

sort all.csv > all_dayly.csv
rm -f all.csv
while read p; do
  echo $(echo "$p" | awk '{ sub("^.*=====",""); print $0; }') >> all.csv
done <all_dayly.csv

cp -f all.csv all_dayly.csv
cp -f all.csv all_nightly.csv
