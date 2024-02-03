#!/bin/bash

ItemIn="$(echo "$_p1 $_p2" | sed -e 's/ *$//g')"
Item=$(findtarget "$ItemIn")
[[ ${Item:-null} = null ]] && Item=$(findwhere "$ItemIn")
[[ ${Item:-null} = null ]] && Item=$(findinv "$ItemIn")
[[ ${Item:-null} = null ]] && { echo "There is no $ItemIn."; return;}

#echo "$Item"

NoWrit () {
	echo "There is nothing to be read on that."
	return 0;
}

if [[ -d $Item ]]; then
	if [ -e "$Item"/[Ww]rit.txt ]; then
		cat "$Item"/[Ww]rit.txt
	elif [ -e "$Item"/[Ww]rit.sh ]; then
		. "$Item"/[Ww]rit.sh 
	else
		NoWrit
	fi
else
	#Check if prop
	if cprop "$Item"; then
		#echo "Property Read."
		echo "It says:"
		qprop "writ@writ" "$Item" || NoWrit
	else
	
		#iext "$Item"
		if [[ $(iext "$Item") = .txt ]]; then
			echo "It says: "
			cat "$Item"
		else
			NoWrit
		fi
	fi
fi
