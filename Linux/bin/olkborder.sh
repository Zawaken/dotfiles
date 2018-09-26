#!/bin/sh
# wget -q https://raw.githubusercontent.com/olkb/orders/master/README.md -O - | grep 100005888
RED='\033[0;31m'
NC='\033[0m'
ordernumber="cat olkborders | grep -oh 100005888"
echo "" > olkborders
wget -q https://raw.githubusercontent.com/olkb/orders/master/README.md -O olkborders
echo -e "Your ordernumber: \"$(cat olkborders | grep -oh 100005888)\" is number${RED}$(cat olkborders | grep 100005888 | cut -c 1-4)${NC} in the order queue."
rm olkborders
