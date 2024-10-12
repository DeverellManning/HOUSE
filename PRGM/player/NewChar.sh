#!/bin/bash

#This file prompts the user on character data.
#Then it makes a charcter folder based on the user's wishes.
#This file should not be sourced.


qprop='./PRGM/data/Qprop.sh'
cprop='./PRGM/data/Cprop.sh'

#Utilities
_util_sources="$_util_sources
./PRGM/data/PropertyUtil.sh
./PRGM/utility/FilesUtil.sh
./PRGM/utility/RandomUtil.sh
./PRGM/utility/OutputUtil.sh
./PRGM/utility/LineUtil.sh
./PRGM/utility/CharacterInterationUtil.sh"

_reload
#End Utilities

#Functions
rand () {
	shuf -e $(seq "$1" "$2") | head -n1
}
getLine () {
	cat $1 | head -n$2 | tail -n1
}

inchestofeet () {
	local feet=$(( $1 / 12 ))
	echo "$feet' $(( $1 - (feet*12) ))\""
}

r3d6 () {
	echo $((`rand 1 6` + `rand 1 6` + `rand 1 6` ))
}
. ./PRGM/utility/ColorUtil.sh



#Guide
guide () {
	clear
	if [ $gt ]; then
	case $1 in
	i)
		echo "Guide-Intro"
		echo "	Welcome to the Character Creator!"
		echo "	This is where you will make a new charcter for the House"
		echo "	Project.  Don't stress it to much!  In the future, you will"
		echo "	be able to change most aspects of your character with the"
		echo "	(inprogress)"
		echo "		When feeding the creator, remember a few things.  First"
		echo "	of all, normally the capitalization of input does not matter" 
		echo "	except when it gets used with out proccessing, like the Name"
		echo "	Try to follow all other input rules, such as (Y/N), meaning"
		echo "	Yes or No.  All effort, with in reason, is made to ensure" 
		echo "	that if your input is not understood, you will be alerted."
		echo " 		Lastly, type help ( No Caps ) at any time to see extra"
		echo "	info, or this guide, and Have Fun in the House Project"
		echo;;
	1)
		echo "______GUIDE______"
		echo "Step One"
		echo "		First, enter the name and species of your character."
		echo "	This will determine several important characteristics that"
		echo "	can affect the character generation proccess, as well as"
		echo "	the character itself.  The Name is what your character is"
		echo "	called and refered to"
		echo "		At the end, you will be prompted for your character's gender."
		echo "	This will change little in the simulation of the game, but"
		echo "	is important for textual output.  Enter Male, Female, or"
		echo "	Unspecified."
		echo;;
	2)
		echo WIP;;
	esac
	read -p"(Press Enter)" var
	echo
	else
		true
	fi
}

#Main
clear
echo "Character Creator"
echo

qm=false;
gt=false;

echo "You are logged in as $_username"

if [[ ${_username:-nuLL} == nuLL ]]; then
	echo "Uh-Oh. You are not logged in!  You can not play"
	echo "Or make characters with out an account.  Accounts"
	echo "are generally free, so I suggest you get one."
	pause
	exit
fi

echo "You are logged in as $_username"

	
echo "Do you want a guide? (Y/N)"
read in;
if [ "`echo $in | cut -c 1 | tr 'A-Z' 'a-z'`" = "y" ]; then gt=true; fi

echo "Do you want Quick Mode? (Y/N)"
read in;
if [ "`echo $in | cut -c 1 | tr 'A-Z' 'a-z'`" = "y" ]; then qm=true; fi

startName () {
	read -p "Character's Name: " iname
	idir=$(echo $iname | tr [A-Z] [a-z] | sed -e "s/ /-/g")
	echo $idir
	if [ -e "./DYNAMIC/Player/$idir" ]; then
		echo "That name is Taken! Please try again."
		startName
	fi
}

start () {
	echo "	If you want the species list, type list"
	read -p "$iname's Species: " ispec
	if [ $ispec = list ]; then
	echo "Available Species:"
		cat "./PRGM/player/species/list.txt"
		echo
		read -p "$iname's Species: " ispec
	fi
	ispec=`echo $ispec | tr 'A-Z' 'a-z'`

	valid=$(grep -wi "$ispec" -q ./PRGM/player/species/list.txt && echo false || echo true)
	#echo $valid
	if [ $valid = true ];
	then
		if [ -e "./PRGM/player/species/$ispec" ]; then true;
		else
			echo "That Species does not exist."
			echo
			start
		fi
	fi
	
	read -p "Gender (M/F/U): " igender
	
	igender=$(echo $igender | cut -c 1 | tr 'A-Z' 'a-z')
	case "$igender" in
	m) igender=Male;;
	b) igender=Male;;
	u) igender=Neuter;;
	n) igender=Neuter;;
	f) igender=Female;;
	g) igender=Female;;
	w) igender=Female;;
	*)
		echo "Error in input.  Please enter a biological gender!"
		start;;
	esac
}

Physical1 () {
	export baseH=
	export baseW=
	export iSize=
	echo "Build Types"
	echo "Strength (Down)  by  Weight (Across)    "
	echo "Runner      Body Builder   Sumo Wrestler"
	echo "Dancer      Engineer       Trucker      " 
	echo "Under Eater Secratary      Donut Eater  "
	read -p "Enter Build: " ibuild
	ibuild=$(echo "$ibuild" | tr [A-Z] [a-z] | sed -e "s/ *$//g" | sed -e "s/ /-/g")
	export local bstr=0
	export local bwt=0
	
	case "$ibuild" in
		"runner")
			bstr=+
			bwt=-
		;;"body-builder")
			bstr=+
			bwt=0
		;;"sumo-wrestler")
			bstr=+
			bwt=+
		;;"dancer")
			bstr=0
			bwt=-
		;;"engineer")
			bstr=0
			bwt=0
		;;"trucker")
			bstr=0
			bwt=+
		;;"under-eater")
			bstr=-
			bwt=-
		;;"secratary")
			bstr=-
			bwt=0
		;;"donut-eater")
			bstr=-
			bwt=+
		;;*)
			echo "Error.  $ibuild is an Invalid build type!"
			Physical
			return;;
	esac
	echo "$ibuild"
	echo "Strength $bstr, Weight $bwt."
	
	echo "Heights, comapred to base species height:"
	echo "1. Very Tall"
	echo "2. Tall"
	echo "3. Average"
	echo "4. Small"
	echo "5. Short"
	echo "6. Midget"
	read -p "Pick A Number:" iheight
	iheight=$(echo "$iheight" | tr [A-Z] [a-z] | sed -e "s/ //g" | cut -c 1)
	
	if [ ! $iheight -le 6 ]; then echo "$iheight is not a number!"; Physical1; return; fi
	
	baseH=$(. $SPath/HeightMod.sh "$iheight" "$igender" )
	
	baseW=$(. $SPath/WeightMod.sh "$bwt" "$igender" $baseH)
	
	#Height
	echo "'$baseH'"
	if [ $bstr = + ]; then 
		baseH=$(( baseH + (baseH/90) ))
	fi
	#Weight
	#baseW=$(( baseW ))
	#Size
	iSize=$($SPath/Size.sh $baseH $baseW)
	
	
}

loadstats () {
	MaxHealth=$($qprop maxhealth@Stat "$SPath/stats.prop")
	MaxEnergy=$($qprop maxenergy@Stat "$SPath/stats.prop")
	
	HealSpeed=$($qprop healspeed@Stat "$SPath/stats.prop")
}

looksOne () {
	$SPath/looks.sh || looksOne
	
}

DandD () {
	local i
	echo "Abilities: 1 Strength, 2 Dexterity, 3 Wisdom, 4 Inteligence, 5 Charisma"
	echo "Put ability ID in order of importance, 1 is most important: "
	read in
	declare -a i=($(echo "$in" | sed -e "s/./& /g"))
	#echo "$i: ${i[0]}, ${i[1]}, ${i[2]}, ${i[3]}"
	
	local roll="$(echo -e "$(r3d6)\n$(r3d6)\n$(r3d6)\n$(r3d6)\n$(r3d6)\n" | sort -nr)"
	#echo -e "$roll"
	
	for N in $(seq 0 5)
	do
		
		NN=$(( N + 1 ))
		nroll=$(echo -e "$roll" | head -n$NN | tail -n1)
		case ${i[$N]} in
			1)	str=$nroll;;
				#echo "strength: $str";;
			2)	dex=$nroll;;
				#echo "dexterity: $dex";;
			4)	int=$nroll;;
				#echo "intelligence: $int";;
			3)	wis=$nroll;;
				#echo "wisdom: $wis";;
			5)	cha=$nroll;;
				#echo "charisma: $cha";;
		esac
	done
	#echo Press Enter
	#read var
	
	speed=1		#PLACEHOLDER

}

LongOne () {
	local line=""
	
	#Description
	echo "Enter Description, EOF to finish."
	until [ "$line" = "EOF" ];
	do
		read -r line
		#echo $line
		if [ "$line" != "EOF" ]; then
			Disc="$Disc\n$line"
		fi
	done
	
	#Likes
	line=""
	echo "Enter things you like, EOF to finish."
	until [ "$line" = "EOF" ];
	do
		read -r line
		#echo $line
		if [ "$line" != "EOF" ]; then
			Like="$Like\n$line"
		fi
	done
	
	#DisLikes
	line=""
	echo "Enter things you don't like, EOF to finish."
	until [ "$line" = "EOF" ];
	do
		read -r line
		#echo $line
		if [ "$line" != "EOF" ]; then
			Dislike="$Dislike\n$line"
		fi
	done
}


# - - - STEPS - - - - #
StepOne () {
	guide 1
	startName
	start

	echo "Name:		$iname"
	echo "Species:	$ispec"
	echo "Gender:		$igender"
	read -p "Is this to your liking? (Y/N) " in
	if [ "$(echo $in | cut -c 1 | tr 'A-Z' 'a-z')" = "n" ]; then 
		StepOne
	fi

	export SPath="./PRGM/player/species/$ispec"

	StepTwo
}
StepTwo () {
	guide 2
	Physical1
	
	echo "Height: $(inchestofeet $baseH)"
	echo "Weight: $baseW"
	echo "Size:   $iSize"
	read -p "Is this to your liking? (Y/N) " in
	if [ "$(echo $in | cut -c 1 | tr 'A-Z' 'a-z')" = "n" ]; then 
		StepTwo
	fi
	StepThree
}
StepThree () {
	guide 3
	loadstats
	
	if [[ ! $qm ]]; then
		looksOne
	fi
	
	echo "Maximum Health: $MaxHealth"
	echo "Maximum Energy: $MaxEnergy"
	   
	read -p "Is this to your liking? (Y/N) " in
	if [ "$(echo $in | cut -c 1 | tr 'A-Z' 'a-z')" = "n" ]; then 
		StepThree
	fi
	StepFour
}

StepFour () {
	guide 4
	DandD
	echo "strength: $str";
	echo "dexterity: $dex";
	echo "intelligence: $int";
	echo "wisdom: $wis";
	echo "charisma: $cha";
	read -p "Is this to your liking? (Y/N) " in
	if [ "$(echo $in | cut -c 1 | tr 'A-Z' 'a-z')" = "n" ]; then 
		StepFour
	fi
	StepFive
}

StepFive () {
	start="/House/Second Floor/Master Bedroom"
	if [[ ! $qm ]]; then
		guide 5
		LongOne
		
		echo

		echo "Description:"
		echo -e $Disc
		echo "Likes:"
		echo -e $Like
		echo "Dislikes:"
		echo -e $Dislike
		echo
		read -p "Is this to your liking? (Y/N) " in
		if [ "$(echo $in | cut -c 1 | tr 'A-Z' 'a-z')" = "n" ]; then 
			StepFive
		fi
	fi
}


FinalCheck () {
	true
}

#Start Here
guide i
clear
StepOne

FinalCheck

. ./PRGM/player/NewSave.sh

