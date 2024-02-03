#!/bin/bash

DoorMain () {
	test=$1 #Where the door goes to
	
	#echo "Door goes to: '$test'"
	
	if [ -e "$test/Name.txt" ]; then
		echo "You walk through the door, into the"
		
		 _where="$1"
		 clein
		. PRGM/SH/look.sh
	else
		ErrorMissingRoom
		echo "Error!"
	fi
}


DoorParam () {
	local doorloc=
	doorloc="$_where"/"$1".door
	#echo $(cat "$doorloc" | sed -e 's/\\/\//g')
	#echo "Door is at: '$doorloc'"
	
	if [ -e "$doorloc" ]; then		#IF that door Exists
	
		local doorgo=$(cat "$doorloc" | sed -e 's/\\/\//g')
		
		DoorMain "$doorgo"
	else
		echo "Door not found? Weird."
		doorloc="Door $1"
		#echo $doorloc
		doorloc="$_where"/"$doorloc".door
		if [ -e "$doorloc" ]; then	# Check for door named Door $1
			local doorgo=$(cat "$doorloc" | sed -e 's/\\/\//g')
		
			DoorMain "$doorgo"
		else
			ErrorNoDoor
		fi
	fi
		
		
}

#Errors:
ErrorMissingRoom () {
	echo "This Door goes to a Room that does not exist!  Please Fix!"
	return
}

ErrorNoDoor () {
	echo "You can't find that way!"
	return
}


#Start
echo
#echo DOOR;echo "Action:'$_act' Param1:'$_p1' Param2:'$_p2'"

if [ `echo $_act | tr 'A-Z' 'a-z'` != door ]; then		#Input is the Name of the Door
	dname="$_act $_p1 $_p2"
	dname=`echo $dname | sed -e 's/ *$//g'`				#remove spaces
else

	if [ ${_p1:-null}  = null ]; then 					#Action is 'door', and parameter One does not exist
		read -p "Which Door? " dname
		#_door= Which door? || Set _door=None
	else												#Action is 'door', and parameter One DOES exist
		dname="$_p1 $_p2"
		dname=`echo $dname | sed -e 's/ *$//g'`
	fi
fi
DoorParam "$dname"
	

	
	
