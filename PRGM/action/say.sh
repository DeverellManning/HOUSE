#!/bin/bash

ToMe=
ToYou=$(echo -e "$_name: \"$dirobj\"")

hear=$(find "$(_fwhere)" -iregex ".*\.char")

#echo "$hear"
#echo $(_fwhere)
#_lineCount "$hear"

for line in $(seq 1 $(_lineCount "$hear")); do
	cl=$(_getLine "$hear" $line)
	cp=$(cat "$cl")
	#echo "$cp"
	if [[ -e "$_charpath$cp/mesg" ]]; then
		echo "$ToYou">"$_charpath$cp/mesg"
	elif [[ -e "$cp/mesg" ]]; then
		echo "$ToYou">"$cp/mesg"
	else
		decho "say.sh: oops!"
	fi
done
