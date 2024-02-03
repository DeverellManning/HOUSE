#!/bin/bash

hug () {
	echo "$message"
}

give () {
	echo "$message"
	local gname=$(cat "$who/Name.txt")
	local Item="./$who/Inventory/${par[1]}"
	local Iname=$(inam "Item")

	echo "$gname gives you ${Iname:-something}."
}

systest () {
	echo "Who: $who"
	echo "Action: $action"
	echo "Message: $message"
	echo "Parameters:"
	for N in $(seq 1 ${#par[*]}); do
		if [[ ${par[N]:-null} != null ]]; then 
			echo "  $N - ${par[N]}"
		fi
	done
}

attack () {
	hitpointr=$(echo ${par[1]} | sed -e "s/\"//g")
	decho "Hit Points: $hitpointr"
	echo "$message"
	_health=$((_health - hitpointr))
}

_TAmain () {
	
	case $1 in
	hug)hug;;
	attack) attack;;
	give)give;;
	systest)systest;;
	"")true;;
	*)decho "That transaction is unknown. Here is what I know:"
		systest
		decho "Message from player/transactions.sh";;
	esac
}
