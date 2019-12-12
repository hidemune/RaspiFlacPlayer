#!/bin/bash
#cp "$1" /run
volume=$2
effect=$3

echo Play : 「"$1"」vol: ${volume}
#echo ${volume} > /var/lib/tomcat8/webapps/ROOT/volume
#./volume.sh ${volume}
#omxplayer -o alsa "$1" &

#sudo kill -9 `pgrep vlc`

#rec -t wav - echo 0.8 0.88 0.1 0.4 | aplay &

#amixer cset numid=3 1

#ext=$(echo $1 | rev | cut -c 1-4 | rev)
#if [ "${ext}" = "flac" ]; then
#  play "$1" $effect &
#else
  if [ "$effect" = "" ]; then
    sudo -u pi cvlc --play-and-exit "$1" &
  sleep 2
    xte 'keydown Alt_L'
    xte 'key  '
    xte 'keyup Alt_L'
    sleep 1
    xte 'key x'
  else
    sudo -u pi cvlc --play-and-exit "$1" --audio-filter karaoke &
  fi
#fi
echo Player started.
