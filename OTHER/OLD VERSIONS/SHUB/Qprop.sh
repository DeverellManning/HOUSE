#!/bin/sh

#This script querys a file for a property.
#$1 is the property name in the format name@section
#$2 is the file location

#The property value is echoed to the standered input

#This file should NOT be sourced,
#as it depends on parameters, and does not change any variables.

#echo "Query a Propety"
#echo "    You are quereing the '$2' for \n    the $1 propetry"




#Variables
nl=0		#Line Count

cl=			#Current Line
pl=			#Current Line, Prepared
cursec=		#Current Section
curname=	#Current Property Name
mode=		#mode name

ftest=		#Used for testing the line

pname=		#Name of the Prperty we are looking for.
sname=		#Name of the Section we are looking for.  Starts with @

value=		#This is where we put the value we find!

#Functions
getLine () {
	cat "$1" | head -n$2 | tail -n1
}

typecheck () {
	type=$(echo "$1" | grep -o "\.[^\.]*$" --)
	#echo $type
	
	if [ -d "$1" ]; then
		DirError $1
	fi
	
	case $type in
	".sh") #echo ".sh Supported!";;
	true;;
	".txt") #echo ".sh Supported!";;
	true;;
	".cmd") #echo ".cmd - Properties are supported, but not functionality.";;
	true;;
	".door") #echo ".door Supported!";;
	true;;
	".ref") #echo ".ref Supported!";;
	true;;
	*) echo "Error! $type not recognized!">&2;;

	esac
	return
}


#Errors
ErrorNotFound () {
	echo "Could not find '$2'">&2
	echo "Maybe it does not exist, is corrupted, or you gave a bad path as input.">&2
	exit 1
}

DirError () {
	echo "$1 is a Directory.  These are supported through other means currently.  Sorry!">&2
	exit 1
}

NonPropError () {
	echo "$1 is not  property file, or is invalid.  Please check the file.">&2
	exit 1
}

PropNotFound () {
	echo "Could not find property matching $1.">&2
	exit 1
}


#Start Here

#Fix File, if it has CR
#if [ "$2"
sed -i -e 's/\r//g' "$2"				#Remove this, eventually

if [ -e "$2" ]; then
	typecheck "$2"
	continue
else
	ErrorNotFound "$2"
fi

sname=`echo $1 | sed -e 's/^.*@/@/g'`
pname=`echo $1 | sed -e 's/@.*$//g'`

#echo "Property:$pname, Section:$sname."
nl=$(awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}' "$2")
mode=lv

#Modes:
#lv		Find line with @
#ls		Find correct section
#lp		Find Property
#f		Found it now, finish up
#ml		Reading a multiline value into memory

for N in `seq 1 $nl`
do
	#Get Current Line
	cl=`getLine "$2" $N`

	#Prepare Line
	pl=`echo "$cl" | sed -e 's/^\(#\|::\)*//g'`
	
	#Probe Line
	ftest=`echo $pl | cut -c 1`
	#echo $ftest
	
	#Something
	if [ "$pl" = @end ]; then
		#echo done
		break
	fi
	if [ "$pl" = @End ]; then
		#echo done
		break
	fi
	
	if [ $mode = lv ]; then
		if [ `echo "$pl" | cut -c 1` = @ ]; then
			#echo "Property File - First @ found!"
			mode=ls
			cursec=$pl
		else
			continue
		fi
	fi									#This split in the if-elif chain is IMPORTANT!
	if [ $mode = ls ]; then
		if [ `echo "$pl" | cut -c 1` = @ ]; then
			cursec="$pl"
			#echo "$cursec"
			if [ $cursec = $sname ]; then
				#echo "Section Found!"
				mode=lp
				if [ "$1" = "Disc@Disc" ]; then
					mode=ml
					#echo "Reading Multiliner!"
					continue;
				fi
			fi
		else
			continue
		fi
	elif [ $mode = lp ]; then
		if [ `echo "$pl" | cut -c 1` = @ ]; then PropNotFound $1; fi
		
		curname=`echo "$pl" | sed -e 's/=.*//g' | cut -c 2-`
		#echo $curname
		
		if [ "$curname" = $pname ]; then
			#echo "Property Found!"
			value=`echo $pl | sed -e 's/.*=//g' | sed -e 's/\`//g'`
			value=`echo $value | sed -e "s/\(^'\|'$\)//g"`				#Remove Outside Single Quotes
			#echo $value
			mode=f
			break
		fi
	elif [ $mode = ml ]; then
		if [ `echo "$pl" | cut -c 1` = @ ]; then
			break
		else
			value=$value"$pl\n"
		fi
	fi
	
	
	

	
	
	#Debug Info
	#echo $N
	#echo "'$pl'"

done

if [ $mode = lv ]; then NonPropError; fi

if [ "${value:-null}" != null ]; then
	#echo "Property Found!"
	#echo "Property is: $value"
	echo $value
else
	echo "Property not found. I don't know why. Sorry. X(">&2
	echo "Check line endings.  Those break things.">&2
fi


	



