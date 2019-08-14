#!/bin/bash
apt-get update
apt-get install curlftpfs tar -y
curlftpfs -o codepage=gbk ftp://账户:密码@IP:端口 /mnt
tar -czvf /mnt/bcode/$(cat /var/lib/docker/volumes/bxc_data/_data/node.db | awk -F '"' '{print $12}').tar.gz -C /var/lib/docker/volumes/ bxc_data
umount /mnt
