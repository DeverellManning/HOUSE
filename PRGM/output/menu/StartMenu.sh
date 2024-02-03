#!/bin/sh

emitItem () {
	echo "|  -$1"
}


echo "       HOUSE       "

echo "Characters:"
ls "./WORLD/CHARACTERS/PLAYERS/" -1t | xargs -n 1 echo "  -"
echo

#for FILE in "./DYNAMIC/Player/*"
#do
	#count=(($count + 1))
	
	#echo "$count. $FILE\n"
#done

echo -e "\nOptions:"
echo "N - New Character  "
echo "V - Version        "
echo "C - Changelog      "
echo "Q - Quit Game      "
echo

