#!/bin/bash

gethow () {
	echo "How do you want to wear the ${Iname}?"

	read -rp "> " how
	how=$(echo "$how" | tr [:upper:] [:lower:])
	case $how in
		hat)how=Hat;;
		head)how=Hat;;
		hair)how=Hat;;
		shirt)how=Shirt;;
		body)how=Shirt;;
		bra)how=Shirt;;
		top)how=Shirt;;
		pants)how=Pants;;
		legs)how=Pants;;
		shoes)how=Shoes;;
		socks)how=Shoes;;
		*) echo -e"You can't wear the $Iname that way.\nTry saying a basic clothing type or part of your body."
			gethow ;;
	esac
}

wear () {
	Iname=$(inam "$Item")
	if cprop "$Item"; then
		local type="$(qprop type@Clothing "$Item" | tr [:upper:] [:lower:])"
		#echo "$type"
		
		case $type in
			any)gethow;;
			hat)how=Hat;;
			shirt)how=Shirt;;
			pants)how=Pants;;
			shoes)how=Shoes;;
			*) echo "It seems that you can not wear the $Iname. (2)"
				return;;
		esac
		#echo $how
		local tw
		local wp="wear$how@Clothing"
		echo $wp
		tw=$(qprop $wp "$Item")
		if [[ ${tw:-null} != null ]]; then
			#qprop $wp $Item
			echo -e ${tw@P}
		else
			tw=$(qprop "wear@Clothing" $Item)
			if [[ ${tw:-null} != null ]]; then
				echo -e ${tw@P}
			else
				echo "You put on the $Iname as a $how."
			fi
		fi
		
		mvs "$Item" "$ppath/Clothes/${how}"
		
	else
		echo "It seems that you can not wear the ${Iname:-$dirobj}. (1)"
	fi
}
nothing () {
	#echo "$ppath/Clothes/*"
	#find "$ppath/Clothes/" -iregex ".*/\.?$1[^/]*$"
	local out=$(find "$ppath/Clothes/" -maxdepth 2 -iregex ".*/\.?[^/]*\.[^/]*$" -type f)
	if [[ "${out:-null}" = null ]]; then
		echo "You already aren't wearing anything!"
		return
	fi
	echo "You remove all your clothes."
	out=$(echo "$out" | xargs -I {} ./PRGM/utility/filters/CompleteFilter.sh '{}' | sort -u)
	local pcs=$(echo "$out" | awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}')
	#echo $pcs
	for N in $(seq 1 $pcs); do
		local curPath=$(echo "$out" | head -n$N | tail -n1)
		echo "$curPath"
		mvs "$curPath" "$ppath/Inventory/"
	done
	#echo "$out"
	
}


input="$(echo "$_p1 $_p2" | sed -e 's/ *$//g' )"

if [[ ${input:-null} = null ]]; then
	echo "You are wearing:"
	hats=$(./PRGM/output/ListContent.sh "$ppath/Clothes/Hat" | xargs -I {}  echo '{}, ')
	shirts="$(./PRGM/output/ListContent.sh "$ppath/Clothes/Shirt" | xargs -I {}  echo '{}, ')"
	pants="$(./PRGM/output/ListContent.sh "$ppath/Clothes/Pants" | xargs -I {}  echo '{}, ')"
	shoes=$(./PRGM/output/ListContent.sh "$ppath/Clothes/Shoes" | xargs -I {}  echo '{}, ')
	if [[ ${shirts:-null} != null ]]; then shirts="$shirts as a"; fi
	if [[ ${pants:-null} != null ]]; then pants="$pants as"; fi
	echo "${hats:-Nothing} as a hat."
	echo "${shirts:-No} shirt."
	echo "${pants:-No} pants."
	echo "${shoes:-Nothing} as shoes."
	hats=
	shirts=
	pants=
	shoes=
	return
fi
if [[ $input = "nothing" ]]; then
	nothing
	return
fi
Item=$(findinv "$input" | head -n 1)
if [[ ${Item:-null} = null ]]; then
	Item=$(findwhere "$input")
fi
echo "$Item"
wear
