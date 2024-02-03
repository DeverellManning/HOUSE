#!/bin/sh

aliasck=$(echo "$_bin" | tr [A-Z] [a-z] | sed -e "s/ *$//g" | sed -e "s/-//g")
case "$aliasck" in
"l")
. ./PRGM/action/look.sh
return 0;;

"inv")
. ./PRGM/action/inventory.sh
return 0;;
"leave game"|"im done")
_in=QUIT
return 0;;

n|s|e|w|north|south|east|west|ne|nw|se|sw|northeast|northwest|southeast|southwest|in|out|up|down|enter|exit|leave)
. ./PRGM/transaction/GoDir.sh
return 0;;

"click click click")
echo "After saying 'I want to go home!' three times and clicking your heels, you suddenly appear in..."
_where="/House/Second Floor/Master Bedroom"
clein
. "./PRGM/action/look.sh"
return 0;;

#*) :;;
	#echo "'$aliasck'"
esac
return 1
