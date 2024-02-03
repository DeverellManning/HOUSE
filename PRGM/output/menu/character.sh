#!/bin/bash

#charlist=$(ls "./WORLD/CHARACTERS/PLAYERS/" -1t)
charlist=$(cat "$_userpath/characters")
nc=

for i in $(seq 0 $(_lineCount "$charlist")); do
	l=$(_getLine "$charlist" $i)
	if [[ -e "./WORLD/CHARACTERS/PLAYERS/$l" && ${l:-null} != null ]]; then
		decho "$l exists"
		nc="$l\n$nc"
	fi
done

charlist=$(echo -e "$nc")

echo "Currently, you have $(_lineCount "$charlist") characters:"
echo "$charlist" | xargs -n 1 echo " -"

echo
echo "Type a character's name,"
echo "or type BACK to return to the main menu."

unset charlist