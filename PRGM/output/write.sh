#!/bin/bash

write () {
	
	local tmp
	local ntmp
	if [[ -p /dev/stdin ]]; then
		tmp=$(cat -)
	else
		tmp=$1
	fi
	local wmode=norm
	
	#Loop 1
	for i in $(seq 0 $(_charCount "$tmp")); do

		#Begin Main#
		c=${tmp:$i:1}
		case $wmode in
		norm) 
			case $c in
				\[) local bcur=
					local blist=
					wmode=bracketchoice;;
				*) ntmp=$ntmp$c
			esac
		;;
		bracketchoice)
			case $c in
				\]) blist=${blist:+$blist\\n}$bcur; bcur=;
					local out=$(echo -en "$blist"|shuf|head -n1);
					ntmp=$ntmp$(echo -ne ${out%.})
					wmode=norm; continue;;
				\|) blist=${bcur}${blist:+\\n$blist}; bcur=; continue;;
			esac
			bcur=${bcur}$c
			
		;;
		skipchar) wmode=norm; continue;;
		esac
		#End Main#
	done
	tmp="$ntmp"
	#echo "$tmp"
	
	ntmp=
	wmode=norm
	#Loop 2
	for i in $(seq 0 $(_charCount "$tmp")); do

		#Begin Main#
		c=${tmp:$i:1}
		
		case $wmode in
			norm)
				case $c in
					\\) if [[ ${tmp:$((i+1)):1} = n ]]; then ntmp=$ntmp\\n; fi
						wmode=skipchar
						;;
					\{)	local cstype=
						wmode=curlysub;
						;;
					*) ntmp=$ntmp$c
				esac
				;;
			curlysub)
				if [[ $c = \} ]]; then
					case "$cstype" in
					a|A) local si=1; local nw=; local c1=false; local cn=;
						cn=${tmp:$((i+si)):1}
						while [[ $cn = " " ]]; do
							si=$((si+1))
							cn=${tmp:$((i+si)):1}
						done
						until [[ $cn = " " || $cn =~ "[\,\.\!\?\;\"\']" || ${cn:-null} = null ]]; do
							nw=$nw$cn
							si=$((si+1))
							cn=${tmp:$((i+si)):1}
							#echo "'$cn'"
						done
						ntest=$(echo "$nw" | sed -e "s/[\.\,\'\"\!]//g")
						#echo -n "{!$ntest!}"
						#echo "$Item"
						if [[ -e $Item ]]; then placetocheck="$(echo "$Item" | sed -e "s/[^\/]*$//")";
						elif [[ -e $(_fwhere) ]]; then placetocheck="$(_fwhere)";
						elif [[ -e $ppath ]]; then placetocheck="$ppath/Inventory/";
						else placetocheck=$(pwd); fi
						#echo "$placetocheck"
						
						#find "./WORLD/CHARACTERS/" -maxdepth 2 -iregex ".*$ntest.*"
						#gfind "$nw" "./WORLD/CHARACTERS/PLAYERS/lyda/Inventory"
						#_lineCount "$(gfind "$nw" "./WORLD/CHARACTERS/PLAYERS/lyda/Inventory"))"
						if [[ -e $(find "./WORLD/CHARACTERS/" -maxdepth 2 -iregex ".*$ntest.*" | head -n1) ]]; then
							#echo nothing
							result=
						else 
						
						if [[ $(_lineCount "$(gfind "$ntest" "$placetocheck")") -le 1 ]]; then
							#echo the
							result=the
						elif [[ ${nw:0:1} =~ [AaEeIiOoUuYy] ]]; then
							result=an
						else
							result=a
						fi
						fi
						;;
						
					esac
					if [[ ${result:-null} = null ]]; then wmode=skipchar; else
						wmode=norm
					fi
					if [[ $cstype = A ]]; then result=$(echo "$result" | tr [a-z] [A-Z]); fi
					ntmp=$ntmp$result
					continue
				fi
				cstype=$cstype$c
				;;
			skipchar) wmode=norm; continue;;
		esac
		
	done

	tmp="$ntmp"
	echo -e "$tmp" | fold -s -w 64
	
	ntmp=
	wmode=norm

	#sleep 0.01
	unset tmp
	unset wmode
}

export -f write
