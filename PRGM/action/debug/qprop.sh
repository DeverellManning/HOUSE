#!/bin/bash

prop="$_p1"

loc="`find "$(_fwhere)"/"$_p2".* | head -n 1`"

#./PRGM/SHUB/Qprop.sh "$prop" "$loc"

time value=$(./PRGM/data/Qprop.sh "$prop" "$loc")

sleep 0.5

echo -e "\n$value"

