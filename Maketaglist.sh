#!/bin/bash

if [ $# -ne 1 ]
then
  echo "引数の数:$#" 
  echo "引数に音楽データのディレクトリを設定して下さい。"
  exit 1
fi

files=$1
rm ./all.csv
IFS='
'
images=(`find $files -type f | sort`)

num_images=${#images[*]}
for (( i=0; i<=$num_images; i++ ))
do
  if [ -n "${images[$i]}" ]; then
    java -jar ./jtag.jar "${images[$i]}" >> ./all.csv
  fi
done
