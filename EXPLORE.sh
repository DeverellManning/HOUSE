#!/bin/bash

echo "Starting"

_debug=false

#Load Globals
. ./PRGM/globals.sh

#Load Functions for Starting
. ./PRGM/utility/startfunc.sh
#Startup and login
. ./PRGM/start.sh


#---VARS---
_gameversion="1.0"
_tty="$(tty)"
echo "$_tty"

#Parser
_ptest=false
_in=
_act=
_p1=
_p2=

#Colors
export ChromaTitle="\e[0m\e[4m\e[40m\e[95m"
export ChromaText="\e[0m"
export ChromaInventory="\e[0m\e[43m\e[37m\e[1m"
export ChromaDebug="\e[0m[1;31m[40m"
export ChromaError="\e[0m[1;31m[43m"
export ChromaDefault="\e[0m"

#Player
export ppath= #Player Path
export pname= #Player Folder Name

export _name=  #Player full name
export _sname= #Player short name
export _fwhere= #Path from HOUSE folder to where the player is.
export _where= 	#Path from HOUSE/WORLD/ROOMS to the player's location/
export _lastwhere=  
export _coins=
export _health=
export _target=

#History
hstloc=
hstmov=


#Time
export ttick=0
export tminute=0
export thour=0
export tDay=0

#Testing & Debuging
_sleep=0

#Load Utilities
_util_sources="$_util_sources
./PRGM/data/PropertyUtil.sh
./PRGM/utility/FilesUtil.sh
./PRGM/utility/RandomUtil.sh
./PRGM/utility/OutputUtil.sh
./PRGM/utility/LineUtil.sh
./PRGM/utility/CharacterInterationUtil.sh

./PRGM/player/tick.sh
./PRGM/player/transactions.sh"

_reload

#Setup Traps
. ./PRGM/utility/TRAPS.sh


clein () {
	_act=
	_p1=
	_p2=
}

flush () {
	return 0
	#kill -SIGHUP $_pid_world $_pid_server
	#rclone rc --url :5573 vfs/forget>/dev/null
	#rclone rc --url :5572 vfs/forget>/dev/null
}


#Ticks the Client Once
GameTick() {
	if [[ ! $_sleep -gt 0 ]]; then echo -e "$ChromaDefault"; fi

	#Communicate with Server, then tell it to tick.
	echo -n "$_where">"$ppath/Where"
	echo -n "tick">"./SERVER/tick"
	sleep 0.05
	
	#Time
	ttickn=$(< "./WORLD/time")
	ttick=${ttickn:-$ttick}
	tminute=$(((ttick / 5)%30 * 2))
	thour=$((((ttick / 5) / 30)%24))
	tDay=$((((ttick / 5) / 30) / 24))

	#Player
	MainTick

	#Room Tree Ticking
	#local tw="$_where"
	#until [[ $tw = "." || $tw = "/" || ${tw:-null} = null ]]; do
	#	#echo "$tw/tick.sh"
	#	if [ -e "$tw/tick.sh" ]; then . "$tw/tick.sh"; fi
	#	tw=$(echo "$tw" | sed "s/\/[^\/]*$//")
	#done

	#Move "body"
	if [[ $_lastwhere != "$_where" ]]; then
		_target=
		if [[ -e ${_worldpath}${_lastwhere}/${_name}.char ]]; then
			mv "${_worldpath}${_lastwhere}/${_name}.char" "$(_fwhere)/${_name}.char"
		else
			decho "I fixed a problem with your body."
		fi
		t=$(echo "$_charpath" | sed -e"s/\//./g")
		echo "$ppath" | sed -e"s/$t//"> "$(_fwhere)/${_name}.char"
	fi
	
	#Check Player List
	if [[ ! $(grep -xF "$pname" "./SERVER/players") ]]; then
		echo "$pname" >> "./SERVER/players" #New line, on the end
	fi
	
	#Where Storage
	_lastwhere="$_where"
	

	#echo "Health: $_health, Health Buffer: $_healthbuffer, Max Health: $_maxhealth"
	#echo "Energy: $_energy, Energy Buffer: $_energybuffer, Max Energy: $_maxenergy"

	#if Sleeping/Skipping Turns, Skip Input
	if [ $_sleep -gt 0 ]; then
		. "$_sleepc"
		_sleep=$((_sleep - 1))
		sleep 0.05
	else
		#Normal play, not sleeping:
		_sleep=0
		_sleepc=

		#Unpause message server
		kill -s SIGCONT $_pid_messages
		#Get Input
		echo -ne "\e[96m"
		read -erp"> " _in
		echo -ne "\e[0m"
		#Pause message Server
		kill -s SIGSTOP $_pid_messages
		
		#Run Parser
		. ./PRGM/parser/DirectClause.sh
	fi
	
}

CharacterMenu () {
	clear
	. ./PRGM/output/menu/character.sh

	_act=
	read -rp "> " _act
	if [[ $_act = BACK ]]; then StartMenu; else
	_act=$(echo $_act | tr "[:upper:]" "[:lower:]")

	if [ -e "./WORLD/CHARACTERS/PLAYERS/$_act/Where" ]; then
		if grep -e "^$_act$" ./SERVER/players; then
			echo "That character is already being used."
			echo "Press Enter"
			pause
			CharacterMenu
			
		fi
		if ! grep -e "^$_act$" ./SERVER/USERS/${_username}/characters; then
			echo "You don't own $_act!"
			echo "Press Enter"
			pause
			CharacterMenu
		fi
		
		ppath="./WORLD/CHARACTERS/PLAYERS/"$_act
		pname=$_act
		. ./PRGM/player/LoadChar.sh
		return

	else
		decho "./WORLD/CHARACTERS/PLAYERS/$_act/Where"
		echo "That character does not exist!"
		echo "Press Enter"
		pause
		CharacterMenu
	fi
	fi
}

StartMenu () {
	clear
	. ./PRGM/output/menu/main.sh
	
	_act=
	read -rp "> " -N1 _act
	_act=$(echo $_act | tr "[:upper:]" "[:lower:]")
	echo

	case "$_act" in
	s) CharacterMenu;;
	j) CharacterMenu;;
	q)
		#Exit game
		echo "Goodbye."
		pause
		exit;;
	v)
		echo "Version: $_gameversion"
		echo "Press Enter"
		pause
		StartMenu;;
	a)
		echo "ABOUT.txt"
		echo "Type q when your finished reading."
		less ./ABOUT.txt
		StartMenu;;
	n)
		echo "New Character"
		./PRGM/player/NewChar.sh
		sleep 2
		StartMenu;;
	c)
		echo "Change Log: WIP"
		echo "Press Enter"
		pause
		StartMenu;;
	"")StartMenu;;
	*)echo "That is not possible!"
		pause
		StartMenu;;
		
	esac
	_act=
	_in=



}

Stop () {
	echo "QUITING"
	sleep 0.5
	kill "$_pid_messages"
	echo "Leaving Game..."

	#Remove name from players list
	echo "$(sed -e "s/$pname//g" ./SERVER/players | grep -vx "^$")" > ./SERVER/players
	
	echo "Saving Data..."
	. ./PRGM/player/SaveChar.sh
	sleep 0.5
	echo "Goodbye!  Come back any time!"
}


#___START HERE___#
echo "Press Enter"
pause
while true; do

StartMenu

clear
clein

. "./PRGM/player/tick.sh" #Load Player Ticking Functions
	
#script -a -O ./OTHER/HouseScript.log
_MASTERname=$(cat ./SERVER/master)
if [[ ${_MASTERname:-null} == null || $_MASTERname = $ppath ]]; then
	echo "$ppath" > "./SERVER/master"
	_MASTER=true
	#lxterminal -e "./PRGM/master/master.sh"
	lxterm -iconic -e "./PRGM/master/master.sh" &
	decho "This is the Master Proccess."
else
	_MASTER=false
	decho "$_MASTERname is hosting master."
fi

./PRGM/output/messages.sh &
_pid_messages=$(jobs -p %)
echo "Message Server PID: $_pid_messages"

echo "Welcome, $_name."
read -t 1
echo

. ./PRGM/action/data/where.sh
. ./PRGM/action/look.sh

until [[ "$_in" = "QUIT" ]];
do
	GameTick
done

#Player has Quit,
#Clean up and return to start menu.
Stop
#Really, these things should go in master.sh, but leave echo "END"
	if $_MASTER; then
		echo "END">"./SERVER/tick"
	fi
done
