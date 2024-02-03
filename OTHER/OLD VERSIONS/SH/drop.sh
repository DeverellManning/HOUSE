#!/bin/sh


Item="$_p1 $_p2"
Item=`echo $Item | sed -e 's/ *$//g'`

echo "Item: '$Item'"
if [ ${_target:-null} != null ]; then 
	echo "Target: '$_target'"
fi

if [ "${Item:-null}" = null ]; then
	. ./PRGM/SH/inv.sh
	echo "You drop what?"
	read Item
fi



#Errors

NotExist () {
	echo "You do not have a $Item."
	return
}


if [ ${_target:-null} != null ]; then
	DropFromTarget
else
	echo "Moving item: $Item in inventory to $_where"

	#call :file_name_from_path
	#echo "REAL name is: $REALNAME"
	#type "$ppath/Inventory/$Item"*
	if [ -e "$ppath/Inventory/$Item" ]; then
		mv "$ppath/Inventory/$Item" "$_where"
	elif [ -e "$ppath/Inventory/$Item"* ]; then
		mv "$ppath/Inventory/$Item"* "$_where"
	fi
    


if [ -e "$_where/$Item"* ]; then
	echo "Move Successful!"
elif [ -e "$_where/$Item" ]; then
	echo "Move Successful!"
else
	echo "Move Unsuccessful!"
fi

fi
