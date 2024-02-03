#!/bin/bash

#This script checks if a file is a valid property file.
#It checks to see if it has a line starting with @
#if so, it returns 0
#otherwise, 1
if [[ -f "$1" ]]; then
	sed -i -e 's/\r//g' "$1" #Remove this, eventually
	file=$(< "$1")
	nl=$(_lineCount "$file")
	for N in $(seq 1 $nl)
	do
		#Get and Prepare Line
		pl=$(_getLine "$file" $N | sed -e 's/^\(#\|::\)*//g')
		if [[ "${pl:0:1}" = @ ]]; then
			exit 0 #Success!
		else
			continue
		fi	
	done
	exit 1
else
	exit 1
fi
