#!/bin/bash

#	master.sh

#   This script is started by Explore.sh, then it runs in the 
#background.  Only one instance of it should be started at a 
#time, by any of the clients.  The script has responsibilities
#ticking the world and occupied rooms, managing NPCs, and 
#keeping track of time.

#Update: This script is now nolonger started by any client.
#It should be started seperatly.

#Load Globals
. ./PRGM/globals.sh

#Variables
ctick=		#Tick received from Explore.sh
npcl=		#List of NPCs

regionfile=$(cat ./WORLD/region)	#The region file

PConline=	#List of Online Players
PCwheres=	#Locations of PCs
	
PCregions=	#Regions Occupied by PCs
PCpaths=	#Base Paths of Regions occupied by PC's

#End Variables


#Utilities
_util_sources="$_util_sources
./PRGM/data/PropertyUtil.sh
./PRGM/utility/FilesUtil.sh
./PRGM/utility/RandomUtil.sh
./PRGM/utility/OutputUtil.sh
./PRGM/utility/LineUtil.sh
./PRGM/utility/CharacterInterationUtil.sh"

_reload
#End Utilities


#Functions
getNPC () {
	echo -e "$npcl" | head -n$1 | tail -n1
}

getPC () {
	echo -e "$PConline" | head -n$1 | tail -n1
}

#An echo function for tick.sh's in rooms
echohere () {
	_CharsIn "$here" | _MessageChar "$1"
}

#Region Work
PathToRegion () { #Find the region that contains a path, $1.
	rl=$(echo -e "$regionfile" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
	for rline in $(seq 1 $rl); do
		cl=$(_getLine "$regionfile" $rline)
		cl1=$(echo "$cl" | cut -c 1)
		if [[ $cl1 = \( ]]; then
			curname=$(echo "$cl" | sed -e "s/(//")
			#echo "( - New name: '$curname'"
			continue
		elif [[ $cl1 = \) ]]; then continue; fi
		
		#echo $cl
		
		if [[ $1 =~ $cl ]]; then
			echo "$curname"
			break;
		fi
	done
}

RegionToPaths () { #Find the base path of a region, $1
	if [[ ${1:-null} == null ]]; then return; fi
	
	rl=$(echo -e "$regionfile" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
	
	sl=$(echo -e "$regionfile" | grep -no "$1" | sed -e "s/:.*//" | head -n 1)
	#echo "Start: $sl End: $rl"
	
	for rline in $(seq "$sl" "$rl"); do
		#echo -n "$rline:"
		cl=$(_getLine "$regionfile" $rline)
		#echo "$cl"
		cl1=$(echo "$cl" | cut -c 1)
		if [[ $cl1 = \( ]]; then
			#echo "( - Skipping '$cl'"
			continue;
		elif [[ $cl1 = \) ]]; then break; fi
		echo "${_worldpath}$cl"
	done
}

#Player Work
UpdatePlayerInfo () {
	#Update Player Info
	PConline=$(cat ./SERVER/players | sort -u  | grep -vx "^$")
	
	#Loop through players
	local nl=$(echo -e "$PConline" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
	#echo $nl
	for line in $(seq 1 $nl); do
		local curpc=$(getPC $line)
		if [[ ${curpc:-null} == null ]]; then continue; fi
		local curloc=$(cat "./WORLD/CHARACTERS/PLAYERS/$curpc/Where")
		#echo "$line Adding ${curloc} from $curpc"
		PCwheres=$(echo "${PCwheres}${curloc}\n")
	done
	PCwheres="$(echo "$PCwheres" | grep -vx "^$")"
}

#End Functions


################
#  START HERE  #
################
cd /home/deverell-manning/Public/HOUSE/

#Load Variables
echo "Loading..."
#Time:
ttick=$(cat "./WORLD/time")
echo -e "Time: $ttick\n\n"
echo "Started."


#Repeat Master Ticking
#Until END is sent from User
until [[ $ctick = END ]]; do

	#Getting Ready
	ctick=
	sleep 2										#Wait 2 seconds
	until [[ ${ctick:-null} != null ]]; do		#Wait until any one does a turn
		ctick=$(< ./SERVER/tick)
		sleep 0.05 #min: 0.01
	done
	
	#Tick the Time (ASAP)
	ttick=$((ttick + 1))
		#tminute=$(((ttick / 5)%30 * 2))
		#thour=$((((ttick / 5) / 30)%24))
		#tDay=$((((ttick / 5) / 30) / 24))
	#Save the Time
	echo $ttick > "./WORLD/time"
	
	#Begin
	echo "+____%$ctick%____+"
	echo "|#$ttick"
	echo
	echo -n "">"./SERVER/tick"					#Clear Tick for next turn
	
	
	#Reset Some Variables
	PCwheres=
	PCregions=
	PCpaths=
	

	sleep 0.1
	UpdatePlayerInfo
	
	echo -e "Online Players:\n$PConline;\n"
	echo -e "Locations of Players:\n$PCwheres;\n"
	
	
	#Load Region Variables
	nl=$(echo -e "$PCwheres" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
	for line in $(seq 1 $nl); do
		curRegion="$(PathToRegion "$(_getLine "$PCwheres" $line)")";
		if [[ ${curRegion:-null} == null ]]; then continue; fi 
		PCregions="$(echo "${PCregions}$curRegion\n")";
		#PCregions=
		#RegionToPaths "$curRegion"
		PCpaths="${PCpaths}$(RegionToPaths "$curRegion")\n";
	done
	PCregions="$(echo "$PCregions" | sed -e "s/ *//g" | grep -vx "^$" | sort -u)"
	PCpaths="$(echo "$PCpaths" | sort -u | grep -vx "^$")"
	
	echo -e "Active Regions:\n$PCregions;"
	echo -e "Paths of Active Regions:\n$PCpaths;"
	echo "---"
	
	#Tick the World
	. ./PRGM/master/world_tick.sh
	
	#Tick NPC Manager (was disabled)
	. ./PRGM/master/npc_tick.sh
	
	#Reload all utilities
	_reload


	echo
done

#Clean Up, Save, and Quit.

#End all NPCs
echo "Stopping All NPCs:"
for line in $(seq 1 $nl); do
	cl=$(getNPC $line)
	if [[ ${cl:-null} = null ]]; then continue; fi
	echo "END" > "$cl/ctick" &
	echo "Stopped npc: $cl"
done

#Save Time
echo $ttick > "./WORLD/time"


#All Done.  Remove entry from master
echo -n "" > "./SERVER/master"

echo "Done. Press Enter to close."
read -t 4 var

	
