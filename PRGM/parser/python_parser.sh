#!/bin/bash

#VARS
com_path="/home/deverell-manning/Projects/HPE/ELIGOTEXTUM/SERVER/PARSER/"
input_pipe="${com_path}input"
output_pipe="${com_path}output1"

#Send Prompt to Parser Instance and recieve results
prompt="$(echo -En '{"input": "'$(echo -En "$_in" | sed -e 's/"/\\"/g')'", "where": "'$(_fwhere)'", "who": "'$ppath'", "target": "'$target'"}')"
echo -En "$prompt">"$input_pipe"
eval "$(< "$output_pipe")"

echo "Verb: $p_verb"
echo "Quote: $p_quote"
echo "Direction: $p_direction"

#Compile verb list

#Find Verb
verb_loc=$(find "./PRGM/action/" -iname "$p_verb.sh")

if [[ -e $verb_loc ]]; then
	. $verb_loc
fi


