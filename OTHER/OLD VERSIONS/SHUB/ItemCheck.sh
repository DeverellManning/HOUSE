#!/bin/sh

#This program will check for doors and items
#in the location of %_where%

#If found, it will attempt to interact with the item,
#aka going through a door, or typing an 
#item's discription.

#Related to (windows) ItemCheck.cmd

Item="$_act $_p1 $_p2"
Item=`echo $Item | sed -e 's/ *$//g'`
Item=`ponfon $Item`

Iname=`echo "$Item" | grep -o "[^/]*$" -- | sed -e "s/\..*$//g"`
Iext=$(echo "$Item" | grep -o "\.[^\.]*$" --)

echo "ITEM CHECK. Checking for '$Iname' '$Iext' "

#echo "Where='$_where'"

#echo "Path:" "$_where/$_item"

if [ "${Item:-null}" = "null" ]; then
	echo "$Iname not found."
fi

if [ -d "$Item" ];then
	echo "Is a Folder"
elif [ $Iext = .door ]; then 
	#echo "Is a Door"
	i1="$Item"
	. ./PRGM/SH/_door.sh
elif [ $Iext = .txt ]; then
	echo "Is a Basic Item"
fi
