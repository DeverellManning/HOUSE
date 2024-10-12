#!/bin/bash

#Load Utilities
. "./PRGM/globals.sh"



#VARS
com_path="/home/deverell-manning/Projects/HPE/ELIGOTEXTUM/SERVER/PARSER/"
input_pipe="${com_path}input"
output_pipe="${com_path}output1"

#Set test vars
_where="/House/Attic/South Attic"
ppath="$_charpath/PLAYERS/lyda"

_ptest=true



#FUNCTIONS
function gen_prompt () {
	#echo -En '{"input": "'$(echo -nE "$_in" | sed -e "s/[\"\']/\\\&/g")'", "where": "'$(_fwhere)'", "who": "'$ppath'", "target": "'$target'"}'
	echo -En '{"input": "'$(echo -En "$_in" | sed -e 's/"/\\"/g')'", "where": "'$(_fwhere)'", "who": "'$ppath'", "target": "'$target'"}'
}

function parse () {
	#. ./PRGM/parser/DirectClause.sh
	prompt="$(gen_prompt)"
	echo -E "$prompt"
	echo -En "$prompt">"$input_pipe"
	result=""
	time eval "$(< "$output_pipe")"
	echo "Verb: $p_verb"
	echo "Quote: $p_quote"
	echo "Direction: $p_direction"
	
}


_in='I say "How are you doing, my good sir?"'
parse

until [ "$_act" = "QUIT" ];
do
	#Get Input
	echo -ne "\e[96m"
	read -rp"> " _in
	echo -e "\e[0m"
	
	#echo "$_in" 
	
	if [[ "${_in:-null}"  = "null" ]]; then
		continue
	else
		parse
	fi
done
