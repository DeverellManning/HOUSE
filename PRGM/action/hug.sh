#!/bin/bash

ItemIn="$(echo "$_p1 $_p2" | sed -e 's/ *$//g')"
Item=$(findtarget "$ItemIn")
[[ ${Item:-null} = null ]] && Item=$(findwhere "$ItemIn")
[[ ${Item:-null} = null ]] && Item=$(findinv "$ItemIn")
[[ ${Item:-null} = null ]] && { echo "There is no $ItemIn."; return;}

decho "$Item"

NoHug () {
	echo "Don't hug $(inam $Item)!"
	return 0;
}

if [[ $(iext "$Item") == .char ]]; then
	Item=$_charpath$(cat "$Item")
	#echo "Refrence: $Item"
	if [ -e "$Item" ]; then
		echo "You hug $(inam $Item)."
		if [[ $(rand 1 2) == 1 ]]; then
			echo -e ")$_name:hug~\"$_name hugs you tightly!\";">>$Item/transfer
		else
			echo -e ")$_name:hug~\"$_name gives you a big hug.\";">>$Item/transfer
		fi
	else
		echo "hug.sh: Bad Refrence: '$Item'"
	fi

else
	NoHug
fi
