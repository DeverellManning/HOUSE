#!/bin/sh


Item="$_p1 $_p2"
Item=`echo $Item | sed -e 's/ *$//g'`

echo "Item: '$Item'"
if [ "${_target:-null}" != null ]; then 
	echo "Target: '$_target'"
fi

weight=0

if [ "${Item:-null}" = null ]; then 
	echo "You take what?"
	read Item
fi

#Errors
TooHeavy () {
	echo "The $Item is Too Heavy to Pick up, because it wieghs $weight!"
}

Weightless () {
	echo "The $Item is weightless, and therefore, very hard to hold."
}

NotExist () {
	echo "There is no $Item here."
	return
}





weightT () {
	echo "The $Item has a weight of: $weight"
	if [ $weight -eq -1 ]; then Weightless;return; fi
	if [ $weight -gt 10 ]; then TooHeavy;return; fi
	
	echo "Moving item: '$_where/$Item'  to '$ppath/Inventory/"

if [ -e "$loc" ] ; then
	mv "$_where/$Item".* "$ppath/Inventory/"
	#echo "Mov file"
fi
if [ -d "$_where/$Item/" ]; then
	#echo "Mov dir."
	mv "$_where/$Item" "$ppath/Inventory/"
fi

local Message="You pick up the $Item and put it into your deep pockets."
#type "$ppath/Inventory/"$Item
if [ -e "$ppath/Inventory/$Item".* ]; then
	echo "$Message"
elif [ -e "$ppath/Inventory/$Item" ]; then
	echo "$Message"
else
	echo "Move Unsuccessful!"
fi
	
}


if [ "${_target:-null}" != null ]; then
	TakeFromTarget
else

#echo "$_where/$Item"
if [ -d "$_where"/"$Item" ]; then		#Is a Directory
	#echo "$Item is a Directory"
	if [ -e "$_where/$Item/Weight.txt" ]; then
		weight=`cat "$_where/$Item/Weight.txt"`
		weightT
	fi
	if [ -e "$_where/$Item/weight.txt" ]; then
		weight=`cat "$_where/$Item/weight.txt"`
		weightT
	fi
elif [ -e "$_where/$Item".* ]; then
	local loc="`find "$_where"/"$Item".* | head -n 1`"
	weight=`qprop weight@Prop "$loc"`
	weightT
else
	NotExist
fi

fi
