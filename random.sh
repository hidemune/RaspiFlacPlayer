#!/bin/bash
files='./all.csv'

IFS='
' images=(`cat $files`)

preNum=$(cat preNum)

num_images=${#images[*]}
echo MAX : $num_images
if [ "${preNum}" == "" ] ; then
  preNum=-1
fi

for i in {1..32}; do
  nextNum=$(($RANDOM % $num_images))
  if [ "${preNum}" != "${nextNum}" ] ; then
    preNum=${nextNum}
    echo $preNum > preNum
    break
  fi
done

echo $nextNum
IFS='	' fileNm=(${images[$nextNum]})
echo RandomFileName _ "${fileNm[0]}"

vol="${fileNm[4]}"
#echo volumeFromCSV: ${vol}
#echo ${vol} > /var/lib/tomcat8/webapps/ROOT/volume
./PlMusicHireso.sh "${fileNm[0]}" ${vol}
