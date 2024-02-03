#!/bin/sh

while true
do
	read in
	out=$(echo " 1.02 * ( $in - 95 ) " | bc)
	if [ $(echo "$out > 5" | bc) -eq 1 ]; then gt=6; fi
	if [ $(echo "$out <  5" | bc) -eq 1 ]; then gt=-6; fi
	echo "$out + 95" | bc
done
