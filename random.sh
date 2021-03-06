#!/bin/bash
files='./all.csv'

offvocal=オフボーカル

preNum=$(cat preNum)

num_images=$(cat $files | grep -v $offvocal | wc -l)

echo MAX : $num_images
if [ "${preNum}" == "" ] ; then
  preNum=-1
fi

for i in {1..32}; do
  nextNum=$(($RANDOM % $num_images))
  nextNum=$(echo "$nextNum + 1" | bc)
  if [ "${preNum}" != "${nextNum}" ] ; then
    preNum=${nextNum}
    echo $preNum > preNum
    break
  fi
done

echo $nextNum
#IFS='	' fileNm=(${images[$nextNum]})
IFS='	' fileNm=($(cat $files | grep -v $offvocal | sed -n ${nextNum}p ))

echo RandomFileName _ "${fileNm[0]}"

vol="${fileNm[4]}"
#echo volumeFromCSV: ${vol}
#echo ${vol} > /var/lib/tomcat8/webapps/ROOT/volume
./PlMusicHireso.sh "${fileNm[0]}" ${vol}
