#!/bin/bash

Itin=$(echo "$_p1 $_p2" | sed -e 's/ *$//g')

Item="$(findinv "$Itin" | head -n 1)"
if [[ ${Item:-null} = null ]]; then
	Item="`findwhere "$Itin" | head -n 1`"
	if [[ ${Item:-null} = null ]]; then
		echo "There is no $Itin here!"
	fi
fi

#cprop "$loc" && echo "'$loc'"

if cprop "$Item"; then
	local edible=$(qprop edible@Food "$Item")
	if [ "$edible" != true ]; then
		echo "That food is bad.   Don't eat it!"
		return
	fi
	local nut=$(qprop nutrition@Food "$Item")
	local cal=$(qprop calories@Food "$Item")
	#echo "$nut $cal"
	
	local energyplus=$((cal - 9))
	local healthplus=$((nut/cal))
	healthplus=$(echo "$nut/$cal" | bc -l | grep -o "[0.9]*\.[0-9]")
	decho "$energyplus - $healthplus"
	
	if [ $_energybuffer -lt 1000 ]; then
		_energybuffer=$((_energybuffer + energyplus ))
	fi
	if [ $(echo "$_healthbuffer < 4" | bc) -eq 1 ]; then
		_healthbuffer=$(echo "$_healthbuffer + $healthplus" | bc)
	fi
	
	local waterplus=$(qprop water@Food "$loc")
	if [ ${waterplus:-null} = null ]; then true; else
		if [ $_waterbuffer -lt 8 ]; then
			_waterbuffer=$(( waterplus + _waterbuffer ))
		fi
	fi
	
	_OtherCharsIn "$(_fwhere)" | _MessageChar "$_sname ate {a} $(inam $Item)."
	write "You eat {a} $(inam $Item)."
	
	if [ -e "$Item" ]; then
		#echo "Delete!"
		#echo $loc
		delete "$Item"
	fi
	
else
	write "You can't eat {a} $(inam "$Item")."
fi
