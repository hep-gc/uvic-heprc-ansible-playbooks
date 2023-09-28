#!/bin/bash
PI=$(/usr/sbin/ip -o route get 8.8.8.8 | sed "s/^.* dev \([[:alnum:]]*\) .*/\1/g")
IP="$(ip addr show dev $PI | grep -w inet | gawk '{print $2}' | cut -d. -f 1,2).0.0/16"

CORES=$(grep -c 'processor' /proc/cpuinfo)
AVAIL_MEM=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
DISK_SPACE=$(df -H --output=size | tr -d "G","Size" | sort -V -r | head -1)


DISK_SPACE=$(($DISK_SPACE / $CORES / 5 * 4000))
AVAIL_MEM=$(($AVAIL_MEM / $CORES * 9 / 10000000))

echo AVAIL_MEM
echo DISK_SPACE

# add variables to customize file
sed -i "s#IP#$IP#g;" /etc/squid/customize.sh
sed -i "s#VCORE#$CORES#g;" /etc/squid/customize.sh
sed -i "s#CACHE_MEM#$AVAIL_MEM GB#g;" /etc/squid/customize.sh
sed -i "s#CACHE_DIR#$DISK_SPACE#g;" /etc/squid/customize.sh