#!/bin/bash
apt-get install sshpass -y
cat $1 | while read mac ip
do
    export SSHPASS=$2
    sshpass -e ssh -n -t -t -o ConnectTimeout=2 -o StrictHostKeyChecking=no root@$ip '
echo mac='$mac'
sleep 1
name=$(curl -sL ftp://xxhjkl:'$3'@img.xxhjkl.me:21/bcode/ | grep '$mac'|awk "{print \$9}")
echo name=$name
sleep 5
recoverBxc() {
 wget ftp://xxhjkl:'$3'@img.xxhjkl.me:21/bcode/$name -O 1.tar.gz && tar -zxvf 1.tar.gz
 sleep 3
 wget --no-check-certificate https://raw.githubusercontent.com/xxhjkl/bxc/master/bxcr.sh
 bash bxcr.sh
}
check() {
 if [ -z "$name" ] ; then
 exit
 else 
 recoverBxc
 fi
}
check
' & done
