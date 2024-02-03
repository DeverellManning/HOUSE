#!/bin/bash


getLine () {
	cat "$1" | head -n$2 | tail -n1
}

randdoor () {
	local mydoor=$(find "$(_fwhere)" -iname "*.door" | shuf | head -n1 )
	local doorname=$(inam "$mydoor")

	if [ -e "$(_fwhere)/${_name}.char" ]; then
		echo "I'm Here: $_where"
	else
		echo "That was not expected."
		find "$_worldpath/" -iname "${_name}.char"
		twp=$(echo $_worldpath | sed -e "s/\//./g" )
		_where=$(find "$_worldpath/" -iname "${_name}.char" | head -n1 | sed "s/${_name}.char//" | sed -e "s/$twp//")
		echo "'$_where'"
		return
	fi

	echo "Chosen Door: $doorname ( at '$mydoor' )"
	
	if [[ "$mydoor" =~ [Dd]ir ]]; then													#Dir Door
		echo "Dir Door"
		nl=$(awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}' "$mydoor")
		cl="$(getLine "$mydoor" "$(rand 1 $nl)")"
		echo "$cl out of $nl"
		doorgo="$(echo "$cl" | sed -e "s/.*+//g" | sed -e "s/,//"  | sed -e 's/\\/\//g')"
		#echo "$cl" | sed -e "s/.*+//g" | sed -e "s/,//"  | sed -e 's/\\/\//g'
		#echo "$doorgo"
	else
		propdoor=$(cprop "$mydoor" && echo Prop)

		if [ ${propdoor:=non} = non ]; then												#Normal Door
			echo "Non-prop door"
			doorgo=$(cat "$mydoor" | sed -e 's/\\/\//g')
		else																			#Extended Door
			echo "Prop door"
			doorgo=$(qprop Where@Door "$mydoor" | sed -e 's/\\/\//g')
		fi
	fi
	
	echo "Goes to: '$doorgo'"
	if [ ! -e "$_worldpath$doorgo/Name.txt" ]; then echo "Nope! Shouldn't go there!"; return; fi
	if [ ! -e "$(find "$_worldpath$doorgo" -iregex ".*\.door" | head -n 1)" ]; then echo "Nope! Shouldn't go there!"; return; fi
	if [[ ${allowedArea:-null} = null || $doorgo =~ $allowedArea ]]; then
			echo "Valid Door!"
			_where="$doorgo"
			echo "$_where" > "$me/Where"
			mv "$_worldpath$_oldwhere/${_name}.char" "$(_fwhere)"
			
			message="$(mCome)"
			#message="$(mLeave)"
			
	else
		echo "Nope! Not allowed there!"
	fi
}
