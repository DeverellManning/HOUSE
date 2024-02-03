#!/bin/bash

#Utility Functions for interaction with lines of text.

#Prints number of lines of variable $1
_lineCount () {
	echo "$(echo "$1" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')"
}

#Prints number of characters of variable $1
_charCount () {
	_lineCount "$(echo "$1" | sed -e "s/./&\n/g")"
}

#Returns a specific line of text
#	$1 = Text to retrieve line from
#	$2 = Line to Retrieve
_getLine () {
	echo -e "$1" | head -n$2 | tail -n1
}

export -f _lineCount
export -f _charCount
export -f _getLine
