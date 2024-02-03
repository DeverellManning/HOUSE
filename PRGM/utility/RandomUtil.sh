#!/bin/sh

rand () {
	shuf -e $(seq "$1" "$2") | head -n1
}

#In the format 2D4
dice () {
	local dcount=
	local dsize=
	local result=0
	local mode=count
	for c in $(echo $1 | sed -e "s/./& /g"); do
		if [[ $mode = count ]]; then
			if [[ $c = D ]]; then
				#echo "D!"
				mode=size
			else
				dcount=$dcount$c
			fi
		else
			dsize=$dsize$c
		fi
	done
	#echo $dsize
	#echo $dcount
	#echo result
	for i in $(seq 1 $dcount); do
		result=$(($(rand 1 $dsize) + result))
	done
	echo "$result"
}