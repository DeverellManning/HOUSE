#!/bin/sh

echo $ChromaDebug
echo "Inventory Path: $_Ppath/Inventory/"
#echo "Checking Existence of Inventory..."

if [ -d $ppath/Inventory ];
	then
	echo -e "Inventory Found."
	echo
	echo $ChromaInventory[4mInventory[0m
	echo $ChromaInventoryCoins$ChromaInventory
	echo "Current: $_coins"
	echo -n "Saved: "
	cat $ppath/coins.txt
	echo
	echo "Inventory Content:"
	ls "./$ppath/Inventory" --quoting-style=literal -1

	echo $ChromaDefault
	echo "Done!(For Now)"
	
else 
	echo "$_ChromaDefault Oh No! Your inventory apparently DOESN'T EXIST! Do YOU even exist?!"
	sleep 2

fi

