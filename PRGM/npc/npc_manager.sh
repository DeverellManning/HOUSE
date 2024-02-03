#!/bin/bash

#Start New NPC
#For every NPC...
#Check if it's still in player's region
#If it is, send tick
#If it isn't send END


#Vars
npcl=		#List of NPCs
ctick=		#Tick from Explore.sh

regionfile=$(cat ./WORLD/Region.txt)	#The file Region.txt
PCregions=								#Regions Occupied by PCs
PCpaths=								#Base Paths of Regions occupied by PC's
PCwheres=								#Locations of PCs


#Functions
getNPC () {
	echo -e "$npcl" | head -n$1 | tail -n1
}

getLine () {
	echo -e "$1" | head -n$2 | tail -n1
}

PathToRegion () {
	rl=$(echo -e "$regionfile" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
	for rline in $(seq 1 $rl); do
		cl=$(getLine "$regionfile" $rline)
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

RegionToPaths () {
	rl=$(echo -e "$regionfile" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
	
	sl=$(echo -e "$regionfile" | grep -no "$1" | sed -e "s/:.*//" | head -n 1)
	#echo "Start: $sl End: $rl"
	
	for rline in $(seq "$sl" "$rl"); do
		#echo -n "$rline:"
		cl=$(getLine "$regionfile" $rline)
		#echo "$cl"
		cl1=$(echo "$cl" | cut -c 1)
		if [[ $cl1 = \( ]]; then
			#echo "( - Skipping '$cl'"
			continue;
		elif [[ $cl1 = \) ]]; then break; fi
		echo "$cl"
	done
	
	#echo "Done!"; 
}

#START HERE
cd /home/deverell-manning/Public/HOUSE/
echo "">"./PRGM/npc/ctick" &

until [[ $ctick = END ]]; do
	ctick=$(< ./PRGM/npc/ctick)
	echo "%$ctick%"
	
	#Reset Some Variables
	PCwheres=$(cat ./DYNAMIC/players.txt | sed -e "s/[^@]*@//g")
	PCregions=
	PCpaths=
	
	echo "$PCwheres"
	#Load Region Variables
	nl=$(echo -e "$PCwheres" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
	for line in $(seq 1 $nl); do
		curRegion=$(PathToRegion "$(getLine "$PCwheres" $line)")
		PCregions=${PCregions}$curRegion
		#RegionToPaths "$curRegion"
		PCpaths=${PCpaths}$(RegionToPaths "$curRegion")
	done
	echo -e "Active Regions: '$PCregions'"
	echo -e "Paths of Active Regions: '$PCpaths'"
	

	#Start new NPCs
	chars=$(echo -e "$PCpaths" | xargs -I {} find "{}" -iname "*.char")
	if [[ ! ${chars:-null} = null ]]; then
		nl=$(echo -e "$chars" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
		for cline in $(seq 1 $nl); do
			curchar="$(getLine "$chars" $cline)"
			curcharloc="$(< "$curchar")"
			if [ -e "${curcharloc}"/*.live.sh ]; then
				echo "Found NPC! - ${curcharloc} @ $curchar"
				if [[ ! $(echo $npcl | grep "${curcharloc}") ]]; then
					echo "Added"
					lxterminal -t "$(basename "${curcharloc}")" -e "bash ${curcharloc}"/*.live.sh
					npcl=$(echo -e "${npcl}\n${curcharloc}")
				fi
			fi
		done
	fi


	#Tick NPCs
	nl=$(echo -e "$npcl" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
	rl=$(echo -e "$PCregions" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')

	#echo "$nl - $rl"
	for line in $(seq 1 $nl); do				#For every NPC...
		cl=$(getNPC $line)
		if [[ ${cl:-null} = null ]]; then continue; fi
		
		inregion=false
		NPCwhere=$(< "$cl/Where")
		NPCregion=$(PathToRegion "$NPCwhere")
		
		echo -e "\n+ $line $(basename "$cl") @ $NPCregion"

		for rline in $(seq 1 $rl); do			#For every active region...
			if [[ $NPCregion = $(getLine "$PCregions" $rline) ]]; then	
				#echo "Match!"
				inregion=true
				break
			fi
		done
		
		if $inregion; then
			echo "tick" > "$cl/ctick" &			#Tick if in region
			echo "ticking npc: $cl"
		else
			echo "END" > "$cl/ctick" &			#Otherwise, End the NPC
			temp=$(echo "$cl" | sed -e "s/\//./g")
			#echo $temp
			npcl=$(echo -e "$npcl" | sed -e "s/$temp//g")
			echo "Stopped npc: $cl"
		fi
	done
	
	echo
	sleep 0.02
done

#End all NPCs
echo "Stopping All:"
for line in $(seq 1 $nl); do
	cl=$(getNPC $line)
	if [[ ${cl:-null} = null ]]; then continue; fi
	echo "END" > "$cl/ctick" &
	echo "Stopped npc: $cl"
done
echo "Done. Press Enter to close."
read -t 5 var

	
