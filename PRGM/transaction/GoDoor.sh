#!/bin/bash

#This script takes an input at $i1, the file path of a door file
#Then, it interprets that file, and, if possible, changes _where to the end location.

#baseDoor
#BetterDoor
#main

#Errors
ErrorNoDoor () {
	echo "There is no door like that here.  What did you mean?"
}

ErrorMissingRoom () {
	echo "The door is broken.  You can't go through it, because it goes nowhere."
}

#Functions
BaseDoor () {
	_energy=$((_energy-1))
	test=${_worldpath}$1 #Where the door goes to
	#echo "$test"
	if [ -e "$test/Name.txt" ]; then				#Check Door Validity
		echo "You walk through the door, into the"	
		_OtherCharsIn "$(_fwhere)" | _MessageChar "$_sname leaves."
		_where="$1"
		_OtherCharsIn "$(_fwhere)" | _MessageChar "$_sname just arrived."
		clein
		. PRGM/action/look.sh
	else
		ErrorMissingRoom
	fi
}

BetterDoor () {
	local dwhere=
	local dmessage=
	local dlocked=
	local dkey=
	local dlockedmessage=
	

	
	dwhere=$(qprop Where@Door "$1" | sed -e 's/\\/\//g')
	dmessage=`qprop Message@Door "$1"`
	if [ "`qprop Locked@Door "$1"`" = "true" ]; then
		echo "That door is Locked!"
		return
	fi
	
	if [ "${dmessage:-null}" = "null" ]; then
		dmessage="You walk through the door, into the"
	fi

	if [ -e "${_worldpath}$dwhere/Name.txt" ]; then				#Check Door Validity
		echo "${dmessage@P}"
		_energy=$((_energy-1))
		_where="$dwhere"
		clein
		. PRGM/action/look.sh
	else
		ErrorMissingRoom
	fi
}

DoorMain () {
	local doorloc="$1"								#Path to Door
	#echo $(cat "$doorloc" | sed -e 's/\\/\//g')
	#echo "Door is at: '$doorloc'"
	
	if [ -e "$doorloc" ]; then						#IF that door Exists
		if [[ `cprop "$doorloc" && echo true` ]]; then
			#echo "Special Door!"
			BetterDoor "$1"
		else
			local doorgo=$(cat "$doorloc" | sed -e 's/\\/\//g')
			BaseDoor "$doorgo"
		fi
	else
		ErrorNoDoor
	fi

}

DoorMain "$i1"
