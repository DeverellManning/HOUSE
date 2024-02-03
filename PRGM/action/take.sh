#!/bin/bash

Item="$_p1 $_p2"
Item=`echo $Item | sed -e 's/ *$//g'`

#echo "Item: '$Item'"
if [ "${_target:-null}" != null ]; then 
	decho "Target: '$_target'"
fi

weight=0

if [ "${Item:-null}" = null ]; then 
	echo "You take what?"
	read Item
fi

#Errors
TooHeavy () {
	write "{a} $Iname is too heavy to pick up, because it weighs $weight!"
	return 1
}

Weightless () {
	write "{a} $Iname is weightless, and therefore, very hard to hold."
	return 1
}

NotExist () {
	echo "There is no $dirobj here."
	return 1
}
NoRoom () {
	echo "Your pockets are too heavy!"
	return 1
}

getWeight () {
	weight=0
	if [[ $(iext "$1") = .prop ]]; then
		#qprop weight@Prop "$1"
		weight=$(qprop weight@Prop "$1") || weight=0
		return
	fi
	if [[ -d "$1" ]]; then		#Is a Directory
		[ -e $1/[Ww]eight* ] && weight=$(< "$1/"[Ww]eight*)
		return
	fi

}

weightT () {
	if [[ ${weight:=0} -eq 0 ]]; then Weightless; return; fi
	decho "The $Iname has a weight of: $weight"
	if [ "$weight" -le -1 ]; then Weightless; return; fi
	if [ "$weight" -gt 15 ]; then TooHeavy;return; fi
	iweight=$weight
	total=0
	for i in $ppath/Inventory/*; do
		getWeight "$i"
		total=$((weight+total))
	done	
	decho "Pocket Weight: $total"
	if [[ $total -gt 30 ]]; then
		NoRoom
		return 0
	fi
	
	_energy=$((_energy-iweight))
	decho "Moving item: '$Item'  to '$ppath/Inventory/"

	mvs "$Item" "$ppath/Inventory/"
	local Message="You pick up {a} $Iname and put it into your deep pockets.\n"
	#type "$ppath/Inventory/$Iname$Iext"
	if [[ -e "$ppath/Inventory/$(basename "$Item")" ]]; then
		_it=$ppath/Inventory/$(basename "$Item")
		write "$Message"
	elif [[ -e "$ppath/Inventory/"$Iname* ]]; then
		write "$Message"
	else
		decho "Move Unsuccessful!"
	fi
	
}

TakeFromTarget () {
	#find "$_target" -maxdepth 1 -iregex ".*$_target/\.?$1[^/]*$" #".*$_target/\.?$1[^/]*$"
	local out="$(findtarget "$1" | head -n 1)"
	if [ "${out:-null}" = "null" ]; then
		out="$(find "$_target/" -maxdepth 1 -iregex ".*/$1[^\./]*$" | head -n 1)"
	fi
	Item="$out"
	
	Iname=$(inam "$Item")
	Iext=$(echo "$Item" | grep -o "\.[^\.]*$" --)
	Ifull=$(echo "$Item" | grep -o "\.[^\]*$" --)

	decho "Name:$Iname | Extension:$Iext"
	getWeight "$Item"
	decho "Weight: $weight"
	weightT
}




if [ "${_target:-null}" != null ]; then
	TakeFromTarget $Item
	return
else

	#echo "$_where/$Item"
	Item=$(ponfon "$Item")
fi
if [[ ! -e $Item ]]; then NotExist; fi

Iname=$(inam "$Item")
Iext=$(iext "$Item")

getWeight "$Item"
decho "Weight: $weight"
weightT



