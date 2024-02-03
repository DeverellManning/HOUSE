#!/bin/bash

echo "Ticking World."

ticks=

	nl=$(echo -e "$PCwheres" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
	for line in $(seq 1 $nl); do
		echo "$line: $(_getLine "$PCwheres" $line)"
		
		tw="${_worldpath}$(_getLine "$PCwheres" $line)"
		until [[ $tw = "." || $tw = "/" || ${tw:-null} = null ]]; do
			if [ -e "$tw/tick.sh" ]; then
				#echo "	$tw/tick.sh"
				ticks="${ticks}\n${tw}/tick.sh"
			fi
			tw=$(echo "$tw" | sed "s/\/[^\/]*$//")
		done
	done
	ticks=$(echo -en "$ticks" | sort -u  | grep -vx "^$")
	echo "Ticking:"
	
	nl=$(echo -e "$ticks" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
	for line in $(seq 1 $nl); do
		tc=$(_getLine "$ticks" $line)
		echo "$tc"
		#Set Variables used by the tick.sh in rooms
		here=$(echo $tc | sed -e"s/\/tick.sh$//")
		#echo $here
		. "$tc"
	done
	


echo -e "Done ticking world.\n"
