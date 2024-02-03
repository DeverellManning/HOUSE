#!/bin/sh

LookAt () {
	Item="$_p1 $_p2"
	Item=`echo $Item | sed -e 's/ *$//g'`
	
	if [ -d "$_where/$Item" ]; then
		if [ -e "$_where/$Item/Disc.sh" ]; then . "$_where/$Item/Disc.sh"; fi
		if [ -e "$_where/$Item/Disc.txt" ]; then cat "$_where/$Item/Disc.txt"; else
		echo "The $Item is featureless.";
		fi
	elif [ -e "$_where/$Item".* ]; then
		local loc="`find "$_where"/"$Item".* | head -n 1`"
		qprop Disc@Disc "$loc"
	else
		echo "There is no $Item here."
	fi
	
}

Look () {
	echo
	local pname
	if [ "$_where/Name.txt" ]; then pname=$(head -n 1 "$_where/Name.txt"); else
	pname=$(head -n 1 "$_where/name.txt"); fi

	echo " - "$pname" - "

	if [ -e "$_where/Veiw.sh" ]; then . "$_where/Veiw.sh"
	elif [ -e "$_where/veiw.txt" ]; then cat "$_where/veiw.txt"
	elif [ -e "$_where/Veiw.txt" ]; then cat "$_where/Veiw.txt"
	else echo "Uh-oh!  This room has NO DISCRIPTION! HELP!"; fi

	echo
	./PRGM/SHUB/ListContent.sh "$_where"
}


if [ ${_p1:-null} = null ]; then Look; else LookAt;
fi

echo
