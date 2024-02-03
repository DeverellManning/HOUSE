#!/bin/bash

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
typecheck () {
	type=$(echo "$1" | grep -o "\.[^\.]*$" --)
	#echo $type
	
	if [[ -d "$1" ]]; then
		DirError $1
	fi
	
	case $type in
	".sh") #echo ".sh Supported!";;
	true;;
	".prop") #echo ".sh Supported!"
	true;;
	".txt") #echo ".sh Supported!";;
	true;;
	".cmd") #echo ".cmd - Properties are supported, but not functionality.";;
	true;;
	".door") #echo ".door Supported!";;
	true;;
	".ref") #echo ".ref Supported!";;
	true;;
	*) true; #echo "Error! $type not recognized!">&2;;

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
	#echo "Could not find property matching $1.">&2
	echo null
	exit 1
}


#Start Here

#Fix File, if it has CR
#if [ "$2"
sed -i -e 's/\r//g' "$2"				#Remove this, eventually

if [[ -e "$2" ]]; then
	typecheck "$2"
else
	ErrorNotFound "$2"
fi

sname=`echo $1 | sed -e 's/^.*@/@/' | tr [:upper:] [:lower:]`
pname=`echo $1 | sed -e 's/@.*$//' | tr [:upper:] [:lower:]`
fname="$pname$sname"
#echo $fname
file=$(cat "$2")
#echo "Property:$pname, Section:$sname."
nl=$(awk 'BEGIN {count=0; OFS=" "} {count++} END {print count}' "$2")
mode=lv

#Modes:
#lv		Find line with @
#ls		Find correct section
#lp		Find Property
#f		Found it now, finish up
#ml		Reading a multiline value into memory

for N in $(seq 1 $nl)
do
	#Get Current Line
	cl=$(_getLine "$file" $N)
	#echo $cl
	#Prepare Line
	pl=$(echo "$cl" | sed -e 's/^\(#\|::\)*//')
	
	#Probe Line
	ftest=${pl:0:1}
	#echo $ftest
	
	#Skip Comments
	if [[ "$ftest" = "|" ]]; then
		continue;
	fi
	
	#Something
	if [[ $mode != lp ]]; then
		if [[ $pl =~ @[Ee]nd ]]; then
			#echo done
			break
		fi
	fi
	
	if [[ $mode = lv ]]; then
		if [[ "$ftest" = @ ]]; then
			#echo "Property File - First @ found!"
			mode=ls
			cursec=$pl
		else
			continue
		fi
	fi									
#This split in the if-elif chain is IMPORTANT!
	if [[ $mode = ls ]]; then
		if [[ "$ftest" = @ ]]; then
			cursec="$( echo "$pl" | tr [:upper:] [:lower:] )" 
			#echo "$cursec"
			if [[ $cursec = $sname ]]; then
				#echo "Section Found!"
				mode=lp
				if [[ "$fname" = "disc@disc" || "$fname" = "writ@writ" || "$fname" = "interface@interface" ]]; then
					mode=ml
					#echo "Reading Multiliner!"
					continue;
				fi
			fi
		else
			continue
		fi
	elif [[ $mode = lp ]]; then
		if [[ "$ftest" = @ ]]; then PropNotFound $1; fi
		
		curname=$(echo "$pl" | sed -e 's/=.*$//' | tr [:upper:] [:lower:] | sed -e "s/^\`//")
		#echo $curname
		
		if [[ "$curname" = $pname ]]; then
			#echo "Property Found!"
			value=$(echo $pl | sed -e 's/.*=//g' | sed -e "s/\`//g")
			value=$(echo $value | sed -e "s/\(^'\|'$\)//g")				#Remove Outside Single Quotes
			#echo $value
			mode=f
			break
		fi
	elif [[ $mode = ml ]]; then
		if [[ "$ftest" = @ ]]; then
			mode=f
			break
		else
			value=$value"$pl\n"
		fi
	fi
	
	#Debug Info
	#echo $N
	#echo "'$pl'"

done

if [[ $mode = lv ]]; then NonPropError; fi

if [[ "${value:-NNN}" != NNN || $mode = ls ]]; then
	#echo "Property Found!"
	#echo "Property is: $value"
	echo -ne "$value"
else
	#decho $mode>&2
	decho "Property not found. I don't know why. Sorry. X(">&2
	decho "Check line endings.  Those break things.">&2
	exit 1
fi


	



