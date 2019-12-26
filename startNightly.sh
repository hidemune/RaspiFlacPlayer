#!/bin/bash

# ２重起動防止
if [ $(pgrep loop.sh) ] ; then
  exit 0
fi

#cp -f ./all_nightly.csv ./all.csv 
sudo ./loop.sh