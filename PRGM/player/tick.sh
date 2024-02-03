#!/bin/bash


#Functions used to tick the player
#

#Me Tick
#Ticks Health, Food, Water, Air, Temprature, and More

#Please Source this script
#Then execute the functions

#Transactions:
. ./PRGM/player/transactions.sh


HealthTick () {
	#Ceiling Health
	if [ "$_health" -ge "$_maxhealth" ]; then
		_health=$_maxhealth;
	fi

	#Low Health
	if [ $_health -le 2 ]; then
		echo "Your health is very low.  Be careful!";
	elif [ $_health -le 4 ]; then 
		local mod=$(($ttick % 5))
		if [ "$mod" == "0" ]; then
			echo "Your health is low."
		fi
	fi

	#Check if Dead
	if [ $_health -le 0 ]; then
		_health=0
		echo "you dead"
		. ./PRGM/player/$_species/death.sh
	fi

	#Regain Health
	local mod=$(( ttick % _healspeed ))
	if [ $mod -eq 0 ]; then
		if [ "$_health" -lt "$_maxhealth" ]; then
			if [ "$(echo "$_healthbuffer >= 1" | bc)" -eq 1 ]; then
				echo "New Health!"
				_health=$(( _health + 1))
				_healthbuffer=$(echo "$_healthbuffer - 1.0" | bc)
			fi
		fi
	fi
}

EnergyTick () {
	_energy=$(( _energy - 1 ))
	
	if [ "$_energy" -lt "$_maxenergy" ]; then
		if [ $_energybuffer -ge 20 ]; then
			_energy=$(( _energy + 20 ))
			_energybuffer=$(( _energybuffer - 20 ))
		elif [[ $_energybuffer -lt 15 && $_energybuffer -gt 0 ]]; then
			_energy=$(( _energy + _energybuffer ))
			_energybuffer=0
		fi
	fi
	if [ $_energybuffer -lt 1 ]; then
		_energybuffer=0
	fi
	
	if [ $_energy -le 5 ]; then
		_health=$((_health - 1))
		_energy=$((_energy + 11))
	fi
	
}

TransactionTick () {
	#Ticks actions on this player by other characters.
	transfer=$(cat "$ppath/transfer")	#Transfer File
	na=$(echo "$transfer" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')		#Number of Actions
	
	for can in $(seq 1 $na); do		#Loop through actions
		ca=$(echo -e "$transfer" | head -n$can | tail -n1)
		export who=$(echo "$ca" | grep -o ").*:" | sed -e "s/[):]//g")
		export action=$(echo "$ca" | grep -o ":[^ ~]*" | sed -e "s/[):~;]//g" | sed -e "s/ *$//")
		export message=$(echo "$ca" | grep -o "~\".*\";$" | sed -e "s/[):~;\"]//g")
		local plist=$(echo "$ca" | grep -o " [^~;]*~" | sed -e "s/[):~;]//g" | sed -e "s/ *$//" | sed -e "s/^ *//")
		local pc=1		#Counter for loop
		unset par		#Parameter array
		export par=
		until [[ ${plist:-done} = "done" ]]; do
			par[$pc]=
			par[$pc]=$(echo "$plist" | grep -oE -e "^[^ \"]*|^\"[^ \"]*\"")		#Retrieve first parameter

			local fixedcp=$(echo "${par[$pc]}" | tr '/ "' '.')			#For next step

			plist=$(echo "$plist" | sed -e "s/^${fixedcp} *//")			#Remove from list

			par[$pc]=$(echo "${par[$pc]}" | sed -e "s/ *$//" | sed -e "s/^ *//")	#Remove spaces

			#echo "\!\!\!: '${par[$pc]}'"
			#echo "PLIST: '$plist'"
			pc=$((pc+1))
			if [[ $pc -ge 16 ]]; then echo "D1ne."; break; fi
		done
		
		#Debug Info:
		#echo "$who does $action.  Message: '$message'"
		#echo "Params: '${par[@]:-none}'"
		#echo "p0: '${par[0]}'"		#not used
		#echo "$can - '$ca'"
		#Procesing
		action=$(echo "$action" | tr "[:upper:]" "[:lower:]")
		_TAmain "$action"
	done
	echo -ne "" > "$ppath/transfer"
}

MainTick () {
	HealthTick
	EnergyTick
	TransactionTick
}
#Coming Sometime:
#SleepTick
#WaterTick
#AirTick

