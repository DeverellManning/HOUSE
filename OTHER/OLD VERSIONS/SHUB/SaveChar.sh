#!/bin/sh

if [ "$1" != "Silent" ]; then
	echo "Saving $_name to '$ppath'"
	echo "Coins=$_coins"
	echo "Health=$_health"
	echo "Where=$_where"
	if [ ${_yip:-null} != null ]; then 
		echo "Yip Species: $_yip"
	fi
	
	echo
	echo "Also saving Time:"
	echo "Time=$ttick"
	echo
	echo "Press Enter to finalize save."
	read var
fi

echo -n "Sav"
echo $_coins > "./$ppath/coins.txt"
echo $_where > "./$ppath/where.txt"
echo $_health > "./$ppath/Health.txt"
echo $_yip > "./$ppath/Yip.txt"

echo $ttick > "./WORLD/Time.txt"
echo "ed"
if [ "$1" != "Silent" ]; then
echo "Finished Saving!"
fi
