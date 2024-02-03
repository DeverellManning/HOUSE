#!/bin/bash

#Check if lying or sitting
#Check Quality of seat/bed

if [[ $_sleep -gt 0 ]]; then
	if [[ $((_sleep % 4)) = 0 ]]; then
		echo "Sleeping"
	fi
	if [[ $((_sleep % 9)) = 0 ]]; then
		echo "ZZZZZZZZ"
	fi
else
	_sleep=$_p1

	_sleepc=./PRGM/action/sleep.sh
fi
