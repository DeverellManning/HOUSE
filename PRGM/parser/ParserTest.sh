#!/bin/bash

#Load Utilities
. "./PRGM/globals.sh"

_where="/House/Attic/South Attic"
ppath="$_charpath/PLAYERS/.mcparsertester"

_in="I look at the Ladder."
. ./PRGM/parser/DirectClause.sh
_ptest=true


#read -n1 var

until [ "$_act" = "QUIT" ];
do
	#Get Input
	echo -ne "\e[96m"
	read -rp"> " _in
	#read -rp"> " _act _p1 _p2
	echo -e "\e[0m"
	
	#echo "$_in" 
	
	if [ "$(echo "$_act" | tr "[:upper:]" "[:lower:]")" = "quit" ]; then
		quitwarn
	elif [ "${_in:-null}"  = "null" ]; then
		continue
	else
	. ./PRGM/parser/DirectClause.sh
	fi
done
