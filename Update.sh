#!/bin/bash

echo Update All?
read a
if [ "$a" == "y" ]; then
  goto Jikkou
elif [ "$a" == "Y" ]; then
  goto Jikkou
fi

exit 1

:Jikkou
cd /home/pi/git/RaspiFlacPlayer
git stash
git pull
sudo ./JspInstall.sh
echo Reboot now?
read a
if [ "$a" == "y" ]; then
  reboot
elif [ "$a" == "Y" ]; then
  reboot
fi
