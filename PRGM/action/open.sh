#!/bin/bash

test=$(echo "$_p1 $_p2" | sed -e 's/ *$//g')
test=$(ponfon "$test")

if [ -e "$test/"Container.txt ]; then
	_target=$test
	echo "You open the $(inam "$test")."
	_OtherCharsIn "$(_fwhere)" | _MessageChar "$_sname is looking in the $(inam "$test")."

	[[ $(_lineCount "$(ls -1 "$_target")") -gt 2 ]] && echo "In the $(inam "$_target"), there are:" || echo "In the $(inam "$_target"), there is:"
	./PRGM/output/ListContent.sh "$_target"
else
	echo "$(inam "$test") is not a container."
fi

decho "target is $_target"
decho "I LOVE YOU DALLEN!!!"
test=
