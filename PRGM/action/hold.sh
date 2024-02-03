#!/bin/bash

if [ ${_p1:-null} = null ]; then
	if [ ${_hand:-null} = null ]; then
		echo "You are holding nothing."
	else
		echo "You are holding the $(inam $_hand)."
	fi
	return
fi
input="$(echo "$_p1 $_p2" | sed -e 's/ *$//g' )"


if  [[ $input = nothing ]]; then
	echo "You put the $(inam $_hand) back in your pockets."
	return
fi

_hand=$(findinv "$input" | head -n1)
if [[ ${_hand:-null} = null ]]; then
	echo "You don't have that!"
	_hand=
else
	echo "You take the $(inam $_hand) out of your pockets and hold it in your $b_hands."
fi
