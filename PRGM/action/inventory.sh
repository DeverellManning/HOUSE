#!/bin/bash

decho -e "$ChromaDebugInventory Path: $ppath/Inventory/"
#echo "Checking Existence of Inventory..."

if [ -d $ppath/Inventory ]; then
	echo
	echo -e "$ChromaInventory[4m        Inventory        [0m"
	echo -e "${ChromaInventory}You are in possesion of: [0m"
	echo -e "${ChromaInventory}$_coins Coins,                          [0m" | head -c43  | sed -e "s/$/[0m/"
	#echo -n " - Saved: "
	#cat "$ppath/Wallet/Coins"
	echo
	cont=$(ls "./$ppath/Inventory" -1 | sed -e "s/\.[^\.]*$//")
	for i in $(seq 1 $(_lineCount "$cont")); do
		echo -e "${ChromaInventory}  $(_getLine "$cont" $i),                            " | cut -c -43 | sed -e "s/$/[0m/"
	done
	echo -e $ChromaDefault
	#echo "Done!(For Now)"
	
else 
	echo "$_ChromaDefault Oh No! Your inventory apparently DOESN'T EXIST! Do YOU even exist?!"
	sleep 1

fi

