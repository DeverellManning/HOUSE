#!/bin/sh

#This script takes a file location input, $Item
#Then, it finds a discription of the item based on what it is.

if [ "${Item:-null}" = "null" ]; then
	echo "LookAt: No Input Path"
	return
fi

Iname=$(inam "$Item")
Iext=$(iext "$Item")

if [ ! -e "$Item" ]; then
	echo "There is no $(inam "$Item") here."
	return 1
fi
_it=$Item

if [ -d "$Item" ]; then
	if [ -e "$Item/Disc.sh" ]; then . "$Item/Disc.sh"; fi
	if [ -e "$Item/Disc.txt" ]; then cat "$Item/Disc.txt"; else
	echo "The $Iname is featureless.";
	fi
else
	if [[ "$Iext" = ".ref" || "$Iext" = ".char" ]]; then
		Item=$_charpath$(cat "$Item")
		#echo "Refrence: $Item"
		if [ -e "$Item" ]; then
			. "./PRGM/transaction/LookAt.sh"
		else
			echo "LookAt: Bad Refrence: '$Item'"
		fi
		return 0
	fi
	
	if cprop "$Item"; then
		qprop Disc@Disc "$Item"
	else
		if [[ "$Iext" = ".txt" ]]; then
			cat "$Item"
		else
			echo "The $Iname is featureless.";
		fi
	fi
fi
