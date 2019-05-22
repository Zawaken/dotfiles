#!/bin/sh
# wget -q https://raw.githubusercontent.com/olkb/orders/master/README.md -O - | grep 100005888
RED='\033[0;31m'
NC='\033[0m'
ordernumber="100005888"
echo "" > olkborders
wget -q https://raw.githubusercontent.com/olkb/orders/master/README.md -O olkborders
if [ "cat olkborders | grep ${ordernumber}" != "" ]; then
	echo -e "This page was last updated \"$(grep "This page was last generated" olkborders | awk '{print $7, $8, $9, $10, $11, $12, $13}')\""
	echo -e "Your ordernumber: ${RED}${ordernumber}${NC} is number${RED}$(grep ${ordernumber} olkborders | awk '{print " " $1}')${NC} in the order queue."
	echo "Last order on the list: $(tail -n 1 olkborders | cut -c 1-4)"

	echo $(date) >> ~/olkborderqueue
	echo -e "This page was last updated \"$(grep "This page was last generated" olkborders | awk '{print $7, $8, $9, $10, $11, $12, $13}')\"" >> ~/olkborderqueue
	echo -e "Your ordernumber: ${RED}${ordernumber}${NC} is number${RED}$(grep ${ordernumber} olkborders | cut -c 1-4)${NC} in the order queue." >> ~/olkborderqueue
	echo "Last order on the list: $(tail -n 1 olkborders | cut -c 1-4)." >> ~/olkborderqueue
	echo "" >> ~/olkborderqueue
else
	echo "Your order has been shipped or is missing! Yay!"
fi
#cleanup
rm olkborders

