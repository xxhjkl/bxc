#!/bin/bash
sed -i 's/ARCH\/\*/ARCH\/nkn*/g' /opt/nknorg/update.sh
sed -i /web/d /opt/nknorg/update.sh
systemctl restart nkn-update
while [ -z "$AMOUNT" ]
do
	AMOUNT=$(nknc info --balance `cat /opt/nknorg/wallet.json | awk -F '"' '{print $18}'` | grep amount |awk -F '"' '{print $4}')
done
if [[ $AMOUNT == 0 ]]
then
	echo $AMOUNT
else
	echo $AMOUNT
	NONCE=$(nknc info --nonce `cat /opt/nknorg/wallet.json | awk -F '"' '{print $18}'` | grep InTxPool |awk '{print $2}')
	PSWD=$(cat /etc/systemd/system/nkn-node.service | grep ExecStart |awk '{print $4}')
	nknc asset -t -w /opt/nknorg/wallet.json --to NKNQJteAjj46fZpxTxQV88csYkG4xEiaTmMe -v $AMOUNT -f 0 --nonce $NONCE -p $PSWD
fi
sleep 5
systemctl restart nkn-node
