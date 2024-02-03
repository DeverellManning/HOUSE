#!/bin/bash

#Load Utilities
. "./PRGM/data/PropertyUtil.sh"
. "./PRGM/utility/FilesUtil.sh"
. "./PRGM/utility/RandomUtil.sh"
. "./PRGM/utility/OutputUtil.sh"

_where="./WORLD/House/Attic/South Attic"
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
