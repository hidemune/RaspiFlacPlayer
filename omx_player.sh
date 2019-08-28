#!/bin/bash
#cp "$1" /run
volume=$2

echo Play : 「"$1"」vol: ${volume}
echo ${volume} > /var/lib/tomcat8/webapps/ROOT/volume
./volume.sh ${volume}
#omxplayer -o alsa "$1" &
rate=$(metaflac --show-sample-rate "$1")
if [ $rate -lt 50000 ]; then
  echo "Upsampling : 192k 32bit"
  AUDIODEV=hw:0 AUDIODRIVER=alsa play "$1" -r 192k -b 32 &
else
  AUDIODEV=hw:0 AUDIODRIVER=alsa play "$1" &
fi
