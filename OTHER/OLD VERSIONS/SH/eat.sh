#!/bin/sh

Item="$_p1 $_p2"
Item=`echo $Item | sed -e 's/ *$//g'`

loc="`find "$_where"/"$Item".* | head -n 1`"

if [ `cprop "$loc" && echo true` ]; then
	qprop Edible@Food "$loc"
fi
