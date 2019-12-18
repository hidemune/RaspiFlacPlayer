#!/bin/bash
#cp "$1" /run
volume=$2
effect=$3

echo Play : 「"$1"」vol: ${volume}
#echo ${volume} > /var/lib/tomcat8/webapps/ROOT/volume
#./volume.sh ${volume}
#omxplayer -o alsa "$1" &

#sudo kill -9 `pgrep play`
#sudo kill -9 `pgrep vlc`

ext=$(echo $1 | rev | cut -c 1-4 | rev)
if [ "${ext}" = "flac" ]; then
  rate=$(metaflac --show-sample-rate "$1")
  if [ $rate -lt 50000 ]; then
    echo "Upsampling : 192k 24bit"
    AUDIODRIVER=alsa play "$1" -r 192k -b 24 $effect &
  else
    AUDIODRIVER=alsa play "$1" $effect &
  fi
else
  sudo -u pi cvlc --play-and-exit "$1" &
  for i in {0..45}; do
    if [ "$(xdotool search --onlyvisible --name vlc)" != "" ] ; then
      if [ -f /var/lib/tomcat8/webapps/ROOT/stop ] ; then
        break
      fi
      sleep 1
      xte 'keydown Alt_L'
      xte 'key  '
      xte 'key \ '
      xte 'keyup Alt_L'
      sleep 1
      xte 'key x'
      break
    fi
    sleep 1
  done
fi
echo Player started.
