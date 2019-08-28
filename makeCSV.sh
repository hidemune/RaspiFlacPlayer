#!/bin/bash

musicpath=/home/pi/Music/
rm -f all.csv
IFS='
'
for f in $(find ${musicpath} -name '*.flac'); do
  fname=$f
  tracknumber=0000$(echo $(metaflac --show-tag=tracknumber "$f") | awk '{ sub("^.*=",""); print $0; }')
  num=$(echo ${tracknumber} | rev | cut -c 1-3 | rev)

  artist=$(echo $(metaflac --show-tag=artist "$f") | awk '{ sub("^.*?=",""); print $0; }')
  album=$(echo $(metaflac --show-tag=album "$f") | awk '{ sub("^.*?=",""); print $0; }')
  title=$(echo $(metaflac --show-tag=title "$f") | awk '{ sub("^.*?=",""); print $0; }')

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
