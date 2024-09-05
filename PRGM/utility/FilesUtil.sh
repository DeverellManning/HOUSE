#!/bin/bash

findwhere () {
	local out
	if [[ "$(echo $1 | sed -e "s/[[:space:]]//g")" = "" ]]; then
		echo "No Input!">&2
		return
	fi
	if [[ $1 = ALL ]]; then
		out="$(find "$(_fwhere)" -maxdepth 1 | xargs -I {} ./PRGM/utility/filters/CompleteFilter.sh '{}' | sort -Ru)"
		echo -e "$out"
		return
	fi
	if [[ $1 =~ ^[Ii][Tt]$ ]]; then
		if [[ -e $_it ]]; then
			#Should we check here if $_it is in the player's sphere of influence?
			decho "findwhere(): It">&2
			out="$_it"
			echo -e "$out"
			return
		fi
	fi

	if [[ $1 =~ ...+ ]]; then
		local l=t
	else
		local l=f
	fi
	
	out=$(find "$(_fwhere)" -maxdepth 1 -iregex ".*/\.?$1[^/]*$")
	if [[ "${out:-null}" = null && $l = t ]]; then
		out=$(find "$(_fwhere)" -maxdepth 1 -iregex ".*/\.?[^/\.]*$1[^/]*$")
	fi
	out=$(echo "$out" | xargs -I {} ./PRGM/utility/filters/CompleteFilter.sh '{}' | sort -u)
	if [[ $l = f ]]; then
		out=$(echo -e "$out" | shuf)
	fi
	echo -e "$out"
}

findtarget () {
	local out
	if [[ "$(echo $1 | sed -e "s/[[:space:]]//g")" = "" ]]; then
		echo "No Input!">&2
		return
	fi
	if [[ "${_target:-null}" = null ]]; then
		#echo "No Input!">&2	#Silently Quit
		echo -e ""
		return
	fi
	if [[ $1 = ALL ]]; then
		out="$(find "$_target" -maxdepth 1 | xargs -I {} ./PRGM/utility/CompleteFilter.sh '{}' | sort -Ru)"
		echo -e "$out"
	fi
	if [[ $1 =~ [Ii][Tt] ]]; then
		if [[ -e $_it ]]; then
			out="$_it"
			echo -e "$out"
			return
		fi
	fi

	
	if [[ $1 =~ ...+ ]]; then
		local l=t
	else
		local l=f
	fi
	
	out=$(find "$_target" -maxdepth 1 -iregex ".*/\.?$1[^/]*$")
	if [[ "${out:-null}" = null && $l = t ]]; then
		out=$(find "$_target" -maxdepth 1 -iregex ".*/\.?[^/\.]*$1[^/]*$")
	fi
	out=$(echo "$out" | xargs -I {} ./PRGM/utility/filters/CompleteFilter.sh '{}' | sort -u)
	if [[ $l = f ]]; then
		out=$(echo -e "$out" | shuf)
	fi
	echo -e "$out"
}

findinv () {
	local out
	
	if [[ "$(echo $1 | sed -e "s/[[:space:]]//g")" = "" ]]; then
		echo "No Input!">&2
		return
	fi
	if [[ $1 = ALL ]]; then
		out=$(find "$ppath/Inventory" -maxdepth 1 | xargs -I {} ./PRGM/utility/filters/BasicFilter.sh '{}' | sort -Ru)
		echo -e "$out"
		return
	fi
	
	if [[ $1 =~ ...+ ]]; then
		local l=t
	else
		local l=f
	fi
	
	out=$(find "$ppath/Inventory" -maxdepth 1 -iregex ".*/\.?$1[^/]*$")
	if [[ "${out:-null}" = null && $l = t ]]; then
		out=$(find "$ppath/Inventory" -maxdepth 1 -iregex ".*/\.?[^/\.]*$1[^/]*$")
	fi
	out=$(echo "$out" | xargs -I {} ./PRGM/utility/filters/BasicFilter.sh '{}' | sort)

	echo -e "$out"
}

gfind () {
	local out
	if [[ "$(echo $1 | sed -e "s/[[:space:]]//g")" = "" ]]; then
		echo "No Input!">&2
		return
	fi
	if [[ $1 = ALL ]]; then
		out="$(find "$2" -maxdepth 1 | xargs -I {} ./PRGM/utility/filters/CompleteFilter.sh '{}' | sort -Ru)"
		echo -e "$out"
		return
	fi
	if [[ $1 =~ [Ii][Tt] ]]; then
		if [[ -e $_it ]]; then
			out="$_it"
			echo -e "$out"
			return
		fi
	fi

	if [[ $1 =~ ...+ ]]; then
		local l=t
	else
		local l=f
	fi
	
	out=$(find "$2" -maxdepth 1 -iregex ".*/\.?$1[^/]*$")
	if [[ "${out:-null}" = null && $l = t ]]; then
		out=$(find "$2" -maxdepth 1 -iregex ".*/\.?[^/\.]*$1[^/]*$")
	fi
	out=$(echo "$out" | xargs -I {} ./PRGM/utility/filters/CompleteFilter.sh '{}' | sort -u)
	if [[ $l = f ]]; then
		out=$(echo -e "$out" | shuf)
	fi
	echo -e "$out"
}

inam () {
	local name
	name=$(echo "$1" | grep -o "[^/]*$" -- | sed -e "s/^\.//g" | sed -e "s/\..*$//g")
	echo -e "$name"
}

iext () {
	local exten
	exten=$(echo "$1" | grep -o "\.[^\.]*$" --)
	echo -e "$exten"
}

ponfon () {
	##if [ "$1" -l  TODO: Test lenght of string, check if it has at leat 3 chars
	#local out="$(find "$_where" -maxdepth 1 -iregex ".*/$1[^/]*\..*$" | head -n 1)"
	#if [ "${out:-null}" = "null" ]; then
		#out="$(find "$_where" -maxdepth 1 -iregex ".*/$1[^/]*$" | head -n 1)"
	#fi
	#echo "$out"
	
	findwhere "$1" | head -n1
}

#Copy, number if duplicate
#cps "./Source/File/Path.txt" "./Destination/Directory"
cps () {
	local dest="$(echo "$2" | sed -e "s/\/$//")"
	local sname="$(echo "$1" | grep -o "[^/]*$" --)"
	if [[ ! -e ${dest}/${sname} ]]; then
		nname=$sname
	elif [[ ! -e ${dest}/$(echo "$sname" | sed -e "s/\.[^.]*$/\.1&/g") ]]; then
		nname=$(echo "$sname" | sed -e "s/\.[^.]*$/\.1&/g")
	else
		#echo -e ":3:\n"
		
		local snam=$(echo "$sname" | sed -e "s/\.[^.]*$//")
		local sext=$(iext "$sname")
		decho "$snam  |  $sext"
		find "$dest" -iregex ".*/$snam\.[0-9]*$sext" | sort -Vr
		local oname=$(find "$dest" -iregex ".*/$snam\.[0-9]*$sext" | sort -Vr | head -n1 | grep -o "[^/]*$" --)
		decho "origname: $oname"
		local n
		local on
		
		on=$(echo "$oname" | grep -o "\.[0-9]*$sext" -- | sed -e "s/\.[^0-9]*//g")
		n=$((on + 1))
		decho "now $n from $on"
		nname=$(echo "$sname" | sed -e "s/\.[^.]*$/\.$n$sext/")
	fi
	decho "Newname: $nname"
	flush
	cp "$1" "${dest}/${nname}"
	unset nname
}

mvs () {
	
	local dest="$(echo "$2" | sed -e "s/\/$//")"
	local sname="$(echo "$1" | grep -o "[^/]*$" --)"
	if [[ ! -e ${dest}/${sname} ]]; then
		nname=$sname
	elif [[ ! -e ${dest}/$(echo "$sname" | sed -e "s/\.[^.]*$/\.1&/g") ]]; then
		nname=$(echo "$sname" | sed -e "s/\.[^.]*$/\.1&/g")
	else
		#echo -e ":3:\n"
		local snam=$(echo "$sname" | sed -e "s/\.[^.]*$//")
		local sext=$(iext "$sname")
		decho "$snam  |  $sext"
		find "$dest" -iregex ".*/$snam\.[0-9]*$sext" | sort -Vr
		local oname=$(find "$dest" -iregex ".*/$snam\.[0-9]*$sext" | sort -Vr | head -n1 | grep -o "[^/]*$" --)
		decho "origname: $oname"
		local n
		local on
		
		on=$(echo "$oname" | grep -o "\.[0-9]*$sext" -- | sed -e "s/\.[^0-9]*//g")
		n=$((on + 1))
		decho "now $n from $on"
		nname=$(echo "$sname" | sed -e "s/\.[^.]*$/\.$n$sext/")
	fi
	decho "NewName: $nname"
	flush
	mv -T "$1" "${dest}/${nname}"
	unset nname
}

delete () {
	flush
	rm -r "$1"
}

move () {
	flush
	mv $*
}

copy () {
	flush
	cp $*
}
