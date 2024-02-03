#!/bin/sh

#This program will check for doors and items
#in the location of %_where%

#If found, it will attempt to interact with the item,
#aka going through a door, or typing an 
#item's discription.

#Related to (windows) ItemCheck.cmd

Item="$_act $_p1 $_p2"
Item=`echo $Item | sed -e 's/ *$//g'`
Item=`ponfon "$Item"`

Iname=`echo "$Item" | grep -o "[^/]*$" -- | sed -e "s/\..*$//g"`
Iext=$(echo "$Item" | grep -o "\.[^\.]*$" --)

#echo "ITEM CHECK. Checking for '$Iname' '$Iext' "

#echo "Where='$_where'"

#echo "Path:" "$_where/$_item"

if [ "${Item:-null}" = "null" -o "$Item" = "." ]; then
	echo "Item Check: $Iname not found."
	return 1
fi

if [ -d "$Item" ];then
	decho "Is a Folder"
	echo "Is familiar."
	return 0
elif [ $Iext = .door ]; then 
	decho "Is a Door"
	i1="$Item"
	. ./PRGM/transaction/GoDoor.sh
	return 0
elif [ $Iext = .txt ]; then
	decho "Is a Basic Item"
	echo "Is quaint."
	return 0
fi

return 1
