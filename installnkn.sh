#!/bin/bash

installNkn(){
rm -rf /tmp/linux*
wget https://raw.githubusercontent.com/sxzcy/nkn-install/master/team/xxhjkl.sh -O /tmp/nkninstall.sh
chmod +x /tmp/nkninstall.sh
bash /tmp/nkninstall.sh
}

installBbr(){
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh -O /tmp/bbrinstall.sh
chmod +x /tmp/bbrinstall.sh
bash /tmp/bbrinstall.sh
}

installNkn
installBbr
