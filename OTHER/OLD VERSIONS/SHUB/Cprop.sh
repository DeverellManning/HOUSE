#!/bin/sh

#This script checks if a file is a valid property file.
#It checks to see if it has a line starting with @
#if so, it returns 0
#otherwise, 1

getLine () {
	cat "$1" | head -n$2 | tail -n1
}

if [ -e "$1" ]; then
sed -i -e 's/\r//g' "$1"		#Remove this, eventually

nl=$(awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}' "$1")

for N in `seq 1 $nl`
do
	#Get and Prepare Line
	pl=`getLine "$1" $N | sed -e 's/^\(#\|::\)*//g'`
	
	#Probe Line
	ftest=`echo $pl | cut -c 1`
	
	if [ `echo "$pl" | cut -c 1` = @ ]; then
		#echo "Property File - First @ found!"
		exit 0 #Success!
	else
		continue
	fi	
done
exit 1
else
exit 1
fi