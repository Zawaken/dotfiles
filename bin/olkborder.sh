#!/bin/sh

RED='\033[0;31m'
NC='\033[0m'
ordernumber="CHANGEME"
echo "" > olkborders
wget -q https://raw.githubusercontent.com/olkb/orders/master/README.md -O olkborders
echo -e "The OLKB orders page was last updated \"$(cat olkborders | grep "This page was last generated" | cut -c 34-64)\""
echo -e "Your ordernumber: ${RED}${ordernumber}${NC} is number${RED}$(cat olkborders | grep ${ordernumber} | cut -c 1-4)${NC} in the order queue."
rm olkborders
