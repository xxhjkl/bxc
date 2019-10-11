#!/bin/bash

cat $1 | while read ip
do
    export SSHPASS=$2
    sshpass -e ssh -n -t -t -o ConnectTimeout=2 -o StrictHostKeyChecking=no root@$ip '
apt-get update
sleep 5
wget --no-check-certificate https://raw.githubusercontent.com/xxhjkl/bxc/master/bxc.sh -O install.sh&&bash install.sh
sleep 5
wget ftp://xxhjkl:ftppass@img.xxhjkl.me:21/bxcback.sh && chmod +x bxcback.sh && ./bxcback.sh
'
done
