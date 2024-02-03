#!/bin/sh

prop="$_p1"

loc="`find "$_where"/"$_p2".* | head -n 1`"

#./PRGM/SHUB/Qprop.sh "$prop" "$loc"

value=`./PRGM/SHUB/Qprop.sh "$prop" "$loc"`

sleep 1

echo $value

