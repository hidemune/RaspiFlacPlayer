#!/bin/bash

unclutter -idle 0.5 -root -visible &

mkdir -p /var/lib/tomcat8/webapps/ROOT/karaoke
rm -f /var/lib/tomcat8/webapps/ROOT/stop
rm -f /var/lib/tomcat8/webapps/ROOT/cancel
rm -f /var/lib/tomcat8/webapps/ROOT/que*

sudo ./jyunbi.sh
mode=0 #SYOKICHI:0

volume=80
./volume.sh 80
export preNum=-1
effect=

rec -t wav - echo 0.8 0.88 0.1 0.4 | aplay &

while true :
do
  # QUE(Yoyaku) !
  lslst=(`ls /var/lib/tomcat8/webapps/ROOT/que* 2>/dev/null`)
  if [ ${#lslst[*]} -gt 0 ] ; then
    # Volume 0%
    #./volume.sh 0
    # QUE
    mode=2 #QUE:2
    qfiles=(`ls /var/lib/tomcat8/webapps/ROOT/que* -1 2>/dev/null`)
    ./PlMusicHireso.sh "`sed -n 1P ${qfiles[0]}`" "`sed -n 2P ${qfiles[0]}`" "`sed -n 3P ${qfiles[0]}`"
    sleep 3
    #echo Kettei : 「"`cat ${qfiles[0]}`"」 
    rm -f ${qfiles[0]}
    while [[ $(pgrep play || pgrep vlc) ]] ; do
      #echo Sleep-A
      sleep 1
      # CANCEL !
      if [ -f /var/lib/tomcat8/webapps/ROOT/cancel ] ; then
        rm /var/lib/tomcat8/webapps/ROOT/cancel
        #trap 'wait $PID' EXIT
        echo CANCEL !!
        sudo killall play
        sudo kill -9 `pgrep vlc`
        break
      fi
      # Volume set
      if [ -f /var/lib/tomcat8/webapps/ROOT/volume ] ; then
        vol=`cat /var/lib/tomcat8/webapps/ROOT/volume`
        #echo VOLUME : ${vol}
        ./volume.sh ${vol}
      fi
      # STOP !
      if [ -f /var/lib/tomcat8/webapps/ROOT/stop ] ; then
        #trap 'wait $PID' EXIT
        echo STOP !!!
        sudo killall play
        sudo kill -9 `pgrep vlc`
        exit 0
      fi
    done
  else
    mode=1 #RANDOM:1
    #break
  fi

  # to RANDOM
  if [ ${mode} -le 1 ] ; then
    mode=1 #RANDOM:1
    if [[ $(pgrep play || pgrep vlc) ]]; then
      :
    else
      echo Random Shell !
      ./random.sh
    fi
  fi

  while [[ $(pgrep play || pgrep vlc) ]] ; do 
    # STOP !
    if [ -f /var/lib/tomcat8/webapps/ROOT/stop ] ; then
      #trap 'wait $PID' EXIT
      echo STOP !!!
      sudo killall play
      sudo kill -9 `pgrep vlc`
      exit 0
    fi
    # CANCEL !
    if [ -f /var/lib/tomcat8/webapps/ROOT/cancel ] ; then
      rm /var/lib/tomcat8/webapps/ROOT/cancel
      #trap 'wait $PID' EXIT
      echo CANCEL !!
      sudo killall play
      sudo kill -9 `pgrep vlc`
      break
    fi
    # Volume set
    if [ -f /var/lib/tomcat8/webapps/ROOT/volume ] ; then
      vol=`cat /var/lib/tomcat8/webapps/ROOT/volume`
      #echo VOLUME : ${vol}
      ./volume.sh ${vol}
    fi
    # mode=1 かつ、キューにある場合、キャンセルボタンと同じにする
    if [ ${mode} -eq 1 ] ; then
      lslst=(`ls /var/lib/tomcat8/webapps/ROOT/que* 2>/dev/null`)
      if [ ${#lslst[*]} -gt 0 ] ; then
        echo que-CANCEL !!
        sudo killall play
        sudo kill -9 `pgrep vlc`
        break
      fi
    fi
    #echo Sleep-B
    sleep 1
  done
done
