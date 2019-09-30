#!/bin/bash
files='./all.csv'

IFS='
' images=(`cat $files`)

num_images=${#images[*]}
echo MAX : $num_images
if [ "${preNum}" == "" ] ; then
  export preNum=-1
fi

for i in 1..5
do
  nextNum=$(($RANDOM % $num_images))
  if [ "${preNum}" != "${nextNum}" ] ; then
    export preNum=${nextNum}
    break
  fi
done

echo $nextNum
IFS='	' fileNm=(${images[$nextNum]})
echo RandomFileName _ "${fileNm[0]}"

vol="${fileNm[4]}"
#echo volumeFromCSV: ${vol}
#echo ${vol} > /var/lib/tomcat8/webapps/ROOT/volume
./PlMusic.sh "${fileNm[0]}" ${vol}
