#!/bin/bash
cp -r /tmp/linux-amd64/certs /opt/nknorg/
cp -r /tmp/linux-amd64/web /opt/nknorg/
systemctl restart nkn-update
