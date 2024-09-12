#!/bin/bash
#Global Vars for everyone!
#This file should be sourced

. ./PRGM/utility/LineUtil.sh


#Global Vars
_worldpath=./WORLD/ROOMS
_charpath=./WORLD/CHARACTERS
_recpath=./WORLD/RESCOURCES

_debug=${debug:-false}

#Global Functions
_fwhere () {
	echo "${_worldpath}${_where}"
}

#Sources
#Files that hold functions, espcilly utility.
#Paths are stored in $_util_sources, and they
#are loaded with _reload function
_reload () {
	#Remove Duplicate Sources
	_util_sources=$(echo -e "$_util_sources" | sort | uniq)

	#Count Sources
	c=$(_lineCount "$_util_sources")
	
	#Load Sources
	for i in $(seq 0 $c); do
		l=$(_getLine "$_util_sources" $i)
		if [[ -e $l ]]; then
			if [[ $1 == true ]]; then echo "$l"; fi  #Log reload proccess if needed.
			. "$l"
		fi
	done

	unset c
	unset l
}

_util_sources="$_util_sources
./PRGM/utility/ColorUtil.sh
./PRGM/utility/FilesUtil.sh
./PRGM/utility/LineUtil.sh
./PRGM/utility/OutputUtil.sh
./PRGM/utility/RandomUtil.sh
./PRGM/data/PropertyUtil.sh"

_reload true

export -f _reload

