#!/bin/bash

echox () {
	builtin echo "Hi! $1"
}

type () {
	tput civis
	local list="$(echo "$1" | sed -e "s/./&\n/g")"
	local nl=$(echo -e "$list" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
	for line in $(seq 1 $nl); do
		echo -ne "$1" | cut -z -c $line
		sleep 0.05
	done
	echo
	tput cnorm
}

v1=Hi
v2=Hi


echox "JK $v1 + $v2"
