#!/bin/bash

cat $1 | while read ip
do
    export SSHPASS=$2
    sshpass -e ssh -n -t -t -o ConnectTimeout=2 -o StrictHostKeyChecking=no root@$ip '
wget https://raw.githubusercontent.com/sxzcy/nkn-install/master/team/xxhjkl.sh -O /tmp/nkninstall.sh
chmod +x /tmp/nkninstall.sh
bash /tmp/nkninstall.sh
'
done
