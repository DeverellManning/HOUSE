#!/bin/bash

#1. Start New NPC
#2. For every NPC...
#   a. Check if it's still in player's region
#   b. If it is, send tick
#   c. If it isn't send END

#Start new NPCs
echo "NPC Manager tick:"
echo "Finding NPCs..."
chars=$(echo -e "$PCpaths" | xargs -I {} find "{}" -iname "*.char" | sort -u)
if [[ ! ${chars:-null} == null ]]; then
	nl=$(echo -e "$chars" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
	for cline in $(seq 1 $nl); do
		curchar="$(_getLine "$chars" $cline)"
		curcharloc="$_charpath$(< "$curchar")"
		echo "$curchar"
		if [ -e "${curcharloc}"/*.live.sh ]; then
			echo "Found $(basename "$curchar"); "
			if [[ ! $(echo $npcl | grep "${curcharloc}") ]]; then
				echo "Found New NPC! - ${curcharloc} @ $curchar"
				xterm -iconic -title "$(basename "${curcharloc}")" -e bash -c "'${curcharloc}'/*.live.sh" &
				npcl=$(echo -e "${npcl}\n${curcharloc}")
			fi
		fi
	done
fi
#echo "$chars"

#lxterm -iconic -title "test" -e bash -c "'./WORLD/CHARACTERS/monsters/Basement Draklen/'*.live.sh" &


#Tick NPCs
echo "Ticking NPCs"

#Line count for NPCs and Regions
nl=$(echo -e "$npcl" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
rl=$(echo -e "$PCregions" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')

for line in $(seq 1 $nl); do				#For every NPC...
	cl=$(getNPC $line)
	if [[ ${cl:-null} = null ]]; then continue; fi
	
	inregion=false
	NPCwhere=$(< "$cl/Where")
	NPCregion=$(PathToRegion "$NPCwhere")
	
	echo -e "+ $line $(basename "$cl") @ $NPCregion"

	for rline in $(seq 1 $rl); do			#For every active region...
		if [[ $NPCregion = $(_getLine "$PCregions" $rline) ]]; then	
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

echo -e "Done ticking NPC manager.\n"
