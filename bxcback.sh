#!/bin/bash
apt-get update
apt-get install net-tools curlftpfs tar -y
curlftpfs -o codepage=gbk ftp://user:pass@img.xxhjkl.me:21 /mnt
#IP=$(ifconfig `ip route | grep default |awk '{print $5}'` | grep "inet " |awk '{print $2}')
MAC=$(cat /var/lib/docker/volumes/bxc_data/_data/node.db | awk -F '"' '{print $12}')
tar -czvf /mnt/bcode/"$MAC".tar.gz -C /var/lib/docker/volumes/ bxc_data
umount /mnt
