#!/bin/bash

. ./PRGM/utility/ColorUtil.sh

	echo "Eye Color: "
	incolor EC
	echo "Hair Color: "
	incolor HC
	echo "Hair Length, inches: "
	read -r in
	if [ "$in" -lt 50 ]; then HL=$in; else 
		echo "Error! That length is invalid!"
		exit 1
	fi
	
	echo "Fur Color: "
	incolor Fur
	echo "Fur Adjectives: "
	read -r FurAdj
	echo "Tail Length, inches: "
	read in
		if [ "$in" -lt 96 ]; then TailL=$in; else 
		echo "Error! That length is invalid!"
		exit 1
	fi
	
	
	
	
