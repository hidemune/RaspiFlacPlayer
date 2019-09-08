#!/bin/bash
#sleep 30
sudo iwconfig wlan0 power off
sudo ifdown --force wlan0 && sudo ifup wlan0
sudo /usr/sbin/hostapd /etc/hostapd/hostapd.conf &
sudo /etc/init.d/isc-dhcp-server start
