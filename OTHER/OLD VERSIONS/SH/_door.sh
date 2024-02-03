#!/bin/sh

#This script takes an input at $i1, the file path of a door file
#Then, it interprets that file, and, if possible, changes _where to the end location.

#baseDoor
#BetterDoor
#main

#Errors
ErrorNoDoor () {
	echo "This door appears to not exist.  Please check your input."
}

ErrorMissingRoom () {
	echo "The door is broken.  You can't go through it, because it goes nowhere."
}

#Functions
BaseDoor () {
	test=$1 #Where the door goes to
	
	if [ -e "$test/Name.txt" ]; then				#Check Door Validity
		echo "You walk through the door, into the"	
		 _where="$1"
		 clein
		. PRGM/SH/look.sh
	else
		ErrorMissingRoom
	fi
}

BetterDoor () {
	echo WIP
}

DoorMain () {
	local doorloc="$1"								#Path to Door
	#echo $(cat "$doorloc" | sed -e 's/\\/\//g')
	echo "Door is at: '$doorloc'"
	
	if [ -e "$doorloc" ]; then						#IF that door Exists
		if [ `cprop "$doorloc" && echo true` ]; then
			echo "Special Door!"
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
