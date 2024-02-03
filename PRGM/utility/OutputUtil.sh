#!/bin/bash

#Utility Functions for output

. ./PRGM/output/write.sh

#TODO: Mode for Use in pipes, like 'write "Hello" | typewriter'
typewrite () {
	if [[ -p /dev/stdin ]]; then
		tmp=$(cat -)
		tmpspd=$1
	else
		tmp=$1
		tmpspd=$2
	fi
	tmpspd=${tmpspd:-0.1}
	for i in $(seq 0 $(_charCount "$tmp")); do
		echo -ne "${tmp:$i:1}"
		sleep $tmpspd
	done
	unset tmp
	unset tmpspd
}

write_file () {
	cat $1
}

write-picture () {
	#TODO:
	#Check $TERM for Xterm
	#other stuff
	convert "$1" six:-
}


pause () {
	read -rN 1
}

decho () {
	$_debug && echo "$1"; sleep 0.2
}
export -f decho
export -f pause
