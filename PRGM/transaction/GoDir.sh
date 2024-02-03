#!/bin/sh

decho "Dir Door"

#getLine () {
#	cat "$1" | head -n$2 | tail -n1
#}

ErrorMissingRoom () {
	echo "GoDir: The door is broken.  You can't go through it, because it goes nowhere."
}

BaseDoor () {
	test="$1" #Where the door goes to
	#echo "$_worldpath$test/Name.txt"
	if [ -e "$_worldpath$test/Name.txt" ]; then				#Check Door Validity
		echo "You $v_walk through the door, to the"	
		 _where="$1"
		 clein
		. PRGM/action/look.sh
	else
		ErrorMissingRoom
	fi
}

DirDoor () {
	_energy=$((_energy-3))
	local Dir="$1"
	case $Dir in
		N|S|E|W)
			true;;
		NE|NW|SE|SW)
			true;;
		NORTH) Dir=N;;
		EAST) Dir=E;;
		SOUTH) Dir=S;;
		WEST) Dir=W;;
		NORTHEAST) Dir=NE;;
		NORTHWEST) Dir=NW;;
		SOUTHEAST) Dir=SE;;
		SOUTHWEST) Dir=SW;;
		IN|OUT)true;;
		ENTER) Dir=IN;;
		EXIT) Dir=OUT;;
		LEAVE) Dir=OUT;;
		DOWN|UP)true;;
	esac

	decho "Dir: $Dir"
	
	if cprop "$dirdoor"; then
		decho "Better Dir Door!"
		
		local dwhere=
		local dmessage=
		
		dwhere=$(qprop where@$Dir "$dirdoor" | sed -e 's/\\/\//g')
		dmessage=`qprop message@$Dir "$dirdoor"`
		
		if [ "${dmessage:-null}" = "null" ]; then
			dmessage="You walk through the door, into the"
		fi

		if [ -e "${_worldpath}$dwhere/Name.txt" ]; then				#Check Door Validity
			echo "${dmessage@P}"
			_energy=$((_energy-1))
			_where="$dwhere"
			clein
			. PRGM/action/look.sh
			return
		else
			echo "You can't go that way."
			return
		fi
		
	
	else
		decho "Normal Dir Door"
		dirdoor=$(cat "$dirdoor")
		for N in $(seq 1 "$(_lineCount "$dirdoor")")
		do
			cl=$(_getLine "$dirdoor" "$N")
			if [ "$(echo "$cl" | sed -e "s/+.*//g" | tr [a-z] [A-Z])" = "$Dir" ]; then
				local test="$(echo "$cl" | sed -e "s/.*+//g" | sed -e "s/,//"  | sed -e 's/\\/\//g')"
				#echo "$test"
				BaseDoor "$test"
				return
			fi
		done
	fi
	
	echo "You can not go that way."
	if $debug; then cat "$dirdoor"; fi
	#cat "$_where/Dir.door" | xargs -n 1 Test
}

#Check for a door named $_win
td=$(findwhere "$_win")
if [[ -e "$td" ]]; then
	i1=$td
	. ./PRGM/transaction/GoDoor.sh
	return
fi

if [[ -e "$(_fwhere)/Dir.door" ]];then
	dirdoor="$(_fwhere)/Dir.door"
	sed -i -e 's/\r//g' "$(_fwhere)/Dir.door"
	Item="$_act $_p1 $_p2"
	Item=$(echo "$Item" | sed -e 's/ *$//g' | tr [a-z] [A-Z] | sed -e "s/-//g")
	DirDoor "$Item"
elif [ -e "$(_fwhere)/dir.door" ]; then
	dirdoor="$(_fwhere)/dir.door"
	sed -i -e 's/\r//g' "$(_fwhere)/dir.door"
	Item="$_act $_p1 $_p2"
	Item=$(echo "$Item" | sed -e 's/ *$//g' | tr [a-z] [A-Z] | sed -e "s/-//g")
	DirDoor "$Item"
else
	echo "You can not go that way. (2)"
fi
