#!/bin/sh


Item="$_p1 $_p2"
Item=`echo $Item | sed -e 's/ *$//g'`

decho "Item: '$Item'"
if [ "${_target:-null}" != null ]; then 
	decho "Target: '$_target'"
fi

if [ "${Item:-null}" = null ]; then
	. ./PRGM/SH/inv.sh
	echo "You drop what?"
	read Item
fi




#Errors

NotExist () {
	echo "You do not have a $Item."
	return
}



DropToTarget () {
	Item=$(findinv "$Item" | shuf | head -n1)
	if [[ ${Item:-null} != null ]]; then
		decho $Item
		bitem=$(basename "$Item")
		mvs "$Item" "$_target"
	fi
	
	Itest=$(find "$_target" -maxdepth 1 -iregex ".*/$bitem" | head -n 1)
	if [ -e "$Itest" ]; then
		decho "Move Successful!"
		echo "You put the $(inam "$Item") into the $(inam "$_target")."
		return
	fi
	
}

_energy=$((_energy-2))

if [ "${_target:-null}" != null ]; then
	DropToTarget
else
	decho "Moving item: $Item in inventory to $(_fwhere)"
	
	IPath=$(find "$ppath/Inventory" -maxdepth 1 -iregex ".*/$Item.*\..*$" | head -n 1)
	echo "$IPath"
	
	if [ -e "$IPath" ]; then
			mvs "$IPath" "$(_fwhere)"
			Itest=$(find "$(_fwhere)" -maxdepth 1 -iregex ".*/$Item.*\..*$" | head -n 1)
			if [ -e "$Itest" ]; then
				echo "Move Successful!"
				return
			fi
	else
		IPath=$(find "$ppath/Inventory" -maxdepth 1 -iregex ".*/$Item.*$" | head -n 1)
		echo "$IPath"
		if [ -d "$IPath" ]; then
			mv "$IPath" "$(_fwhere)"
			Itest=$(find "$(_fwhere)" -maxdepth 1 -iregex ".*/$Item.*$" | head -n 1)
			if [ -e "$Itest" ]; then
				echo "Move Successful!"
				return
			fi
		fi
	fi
	decho "Move Unsuccessful!"
fi
