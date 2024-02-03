#!/bin/bash

if [ "$1" != "Silent" ]; then
	echo "Saving $_name to '$ppath'"
	echo "Coins=$_coins"
	echo "Health=$_health"
	echo "Energy=$_energy"
	echo "Where=$_where"
	if [ ${_yip:-null} != null ]; then 
		echo "Yip Species: $_yip"
	fi
	
	echo
	echo "Press Enter to finalize save."
	read var
fi

echo -n "Sav"
echo $_coins > "./$ppath/Wallet/Coins"
echo $_where > "./$ppath/Where"
echo $_health > "./$ppath/Health"
echo $_energy > "./$ppath/Energy"
echo $_water > "./$ppath/Water"
echo $_yip > "./$ppath/Species"

. ./PRGM/player/species/$_species/Save.sh

echo "$_hand" > "$ppath/Hands"

echo "ed"
if [ "$1" != "Silent" ]; then
echo "Finished Saving!"
fi
