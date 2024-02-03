#!/bin/bash

Item="$_p1 $_p2"
Item=`echo $Item | sed -e 's/ *$//g'`
#echo "$_hand"

if [[ ${Item:-null} = null ]]; then
	if [[ ${_hand:-null} = null ]]; then
		read -p "Use what? " Item
	else
		Item=hand
	fi
fi

_energy=$((_energy-1))

if [[ $Item = hand ]]; then
	Item=$_hand
else
	#ponfon "$Item"
	Itest="$(ponfon "$Item")"
	if [[ ${Itest:-null} = null ]]; then
		Itest=$(findinv "$Item" | head -n1)
	fi
	Item=$Itest
	_it=$Item
fi

Iname=$(inam "$Item")
Iext=$(iext "$Item")

#echo "Using the $Iname."
if [[ ${Iext:=dir} = .sh ]]; then
	. "$Item"
elif [[ -d "$Item" ]]; then
	if [ -e "$Item/"[Uu]se.sh ]; then
		. "./$Item/"[Uu]se.sh
	fi
else
	echo "You can't use the $Iname!"
fi

[[ ${message:null} != null ]] && echo "$message"


