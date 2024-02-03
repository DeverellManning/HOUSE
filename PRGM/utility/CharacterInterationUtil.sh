#!/bin/bash

#This utility library contains useful functions
#for interacting with characters using transactions
#and messages.

#Transaction vs. Message:
#
#A TRANSACTION is an action by a character on another
#character, eg Deverell stabs a draklen.  They are 
#interpreted by the receiver, so that the receiver is
#affected by that action. Transactions have a set format
#and a set of available types.
#
#A MESSAGE is displayed directly on a player's display.
#Messages normally do not affect the receiver, and
#can be used for things like sounds, talking, or variable
#settings.  They, unlike transactions, do NOT have a set
#format.


#Functions for finding characters

#Characters in a location, $1
_CharsIn () {
	find "$1" -iregex ".*\.char"
}
_OtherCharsIn () {
	find "$1" -iregex ".*\.char" -not -iname "${_name}.char"
}


#Receives a list of .char files from a pipe, loops 
#through them, and gives them message $1
_MessageChar () {
	if [[ -p /dev/stdin ]]; then
		chars="$(cat -)"
		
		#echo "CIU #1"
		for i in $(seq 0 $(_lineCount "$chars")); do
			cl=$(_getLine "$chars" "$i")
			if [[ ${cl:-null} = null ]]; then continue; fi
			cp=$_charpath$(cat "$cl")
			#echo -e "$cl:\n$cp\n"
			if [[ -e $cp ]]; then
				echo "$1">"$cp/mesg"
			fi
		done
	fi

	unset cl
	unset cp
}
