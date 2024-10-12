#!/bin/bash


messages=$(cat $ppath/mesg)

if [[ ${messages:-null} != null ]]; then
	tput sc
	nl=$(echo -e "$messages" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
	for line in $(seq 1 $nl); do
		tput ind;
		tput cuu1;
		tput il1;
		echo -ne "\e[0m$(echo -e "$messages" | head -n$line | tail -n1)\e[0m"
		tput cud1;	#Restore Cursor Position
	done
	#tput rc	#Restore Cursor Position
	tput cuf1;tput cuf1;

	#Clear Message File
	echo "">"$ppath/mesg"
fi

if [[ $t != $lt ]]; then
	if [[ $COLUMNS -lt 79 ]]; then return; fi
	col=$((COLUMNS - 16))
	health=$(< $ppath/Health)
	text=$(echo "$t⏲  $health♥               " | cut -c 1-19 -)

	#stty -echo
	tput sc			#Save Cursor Position
	tput civis		#invisible cursor
	tput rev		#Reverse Video

	#tput cup 0 $col
	#tput el
	#echo -en "\e[30m                      \e[33m"

	tput cup 1 $col
	tput el
	echo -en "$text"

	#stty echo
	tput rc			#Restore Cursor Position

	tput cvvis
fi


