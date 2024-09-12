#!/bin/bash

Look () {
	dark=false
	if cprop "$(_fwhere)/Room.prop"; then
		indoors=$(qprop indoors@Room "./WORLD/ROOMS$_where/Room.prop")
		if [[ ! indoors ]]; then
			dark=false
		else
			objs=$(findwhere ALL)
		fi
	fi
	if [[ dark = true ]]; then
		echo -e "$ChromaTitle  Darkness  $ChromaDefault"
		echo "	It is dark here, and you can't see a thing!"
		return
	fi
	echo
	local pname
	if [[ -e "$(_fwhere)/Name.txt" ]]; then pname=$(head -n 1 "$(_fwhere)/Name.txt"); else
	pname=$(head -n 1 "$(_fwhere)/name.txt"); fi

	echo -e "$ChromaTitle  $pname  $ChromaDefault"

	if [ -e "$(_fwhere)/Veiw.sh" ]; then . "$(_fwhere)/Veiw.sh"
	elif [ -e "$(_fwhere)/veiw.txt" ]; then cat "$(_fwhere)/veiw.txt" | fold -s -w 64
	elif [ -e "$(_fwhere)/Veiw.txt" ]; then cat "$(_fwhere)/Veiw.txt" | fold -s -w 64
	else echo -e "This room is oddly featurless.\nIt makes you worried about deadlines and details."; fi

	echo
	./PRGM/output/ListContent.sh "$(_fwhere)"
}



lookatme () {
	echo "You examine your own self.  You see:"
	cat "$ppath/Disc.txt"
}


if [[ ${_p1:-null} = null ]]; then Look; return;
elif [[ "$_p1" = at || "$_p1" = in ]]; then ItemIn="$_p2"; else
ItemIn=$(echo "$_p1 $_p2" | sed -e 's/ *$//g'); fi


if [ "$ItemIn" = "self" ]; then lookatme; return; fi
if [ "$ItemIn" = "me" ]; then lookatme; return; fi
if [ "$ItemIn" = "around" ]; then Look; return; fi

Item=null
Item=$(findtarget "$ItemIn")
[[ ${Item:-null} = null ]] && Item=$(findwhere "$ItemIn")
[[ ${Item:-null} = null ]] && Item=$(findinv "$ItemIn")
[[ ${Item:-null} = null ]] && { echo "There is no $ItemIn."; return;}
#Item=$(echo "$Item" | head -n 1)

if [[ ${Item:-null} = null ]]; then return; fi

if [[ $_p1 = in ]]; then . "./PRGM/transaction/LookIn.sh"; fi
if [[ $_p1 = at ]]; then . "./PRGM/transaction/LookAt.sh"; fi
