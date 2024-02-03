#!/bin/bash

Item=$(echo "$_p1 $_p2" | sed -e 's/ *$//g')
decho "Item: $Item"

decho "It: '$_it'"

#Determine Victim
if [[ ${Item:-null} = null ]]; then
	if [[ ${_it:-null} = null ]]; then
		read -p "Attack who? " Item
	else
		if [[ $( iext "$_it") = .char ]]; then
			Item=$_it
		else
			echo 2
		fi
	fi
fi

Item=$(findwhere "$Item" | head -n1)
echo "Attacking $(inam "$Item")"
_energy=$((_energy-3))

if [[ $(iext "$Item") == .char ]]; then
	transferPath=$_charpath$(cat "$Item")transfer
	if [[ ! -e "$transferPath" ]]; then
		echo "Error: attack.sh 28: Target doesn't have a tranfer file!"
		return
	fi
fi


#Determine Weapon
decho "Hand: $_hand"
if [[ ${_hand:-null} = null ]]; then
	echo "You are not holding anything!"
	return
fi

damage=$(qprop damage@Weapon "$_hand")
if [[ ${damage:-null} != null ]]; then
	hitchance=$(qprop hitchance@Weapon "$_hand")

else
	echo "You aren't holding a weapon."
	return
fi

decho "Hit Dice: $hitchance"
decho "Damage: $damage"

if [[ $(dice "$hitchance") -gt 1 ]]; then
	dice "$damage"
	echo ")$_name:attack~\"$_name is attacking you with a knife!\"">"$transferPath";
else
	echo "You miss!"
fi
