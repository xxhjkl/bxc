#!/bin/bash
cat /opt/nknorg/wallet.json | awk -F'"' '{print $18}'
