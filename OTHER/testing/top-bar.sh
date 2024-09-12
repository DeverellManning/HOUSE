#!/bin/bash

echo Starting

cd /home/deverell-manning/Public/HOUSE/
ls

bd=	#?

#---VARS---

#Function
#SET "_return="

_gameversion="0.2"
_tty="$(tty)"
echo "$_tty"
echo "$_tty">"./DYNAMIC/tty.id.txt"

##Parser
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
export ppath=
export _name=
export _where=
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

#Testing
_sleep=0

#Load Utilities
. "./PRGM/data/PropertyUtil.sh"
. "./PRGM/utility/FilesUtil.sh"
. "./PRGM/utility/RandomUtil.sh"
. "./PRGM/utility/OutputUtil.sh"

pause () {
	read -rN 1
}

quitwarn () {
  echo "Type QUIT in upper case to quit, if you really want too."
}

clein () {
	_act=
	_p1=
	_p2=
}


GameTick() {
	if [[ ! $_sleep -gt 0 ]]; then echo -e "$ChromaDefault"; fi

	#Time
	ttick=$((ttick + 1))
	tminute=$(((ttick / 5)%30 * 2))
	thour=$((((ttick / 5) / 30)%24))
	tDay=$((((ttick / 5) / 30) / 24))

	#Player
	#. "./PRGM/player/tick.sh"

	#Room Tree Ticking - Disabled

	#Previous Room Tree Ticking - Disabled
	
	#Where Storage
	_lastwhere="$_where"
	
	#if [ -e "./$_where/tick.sh" ]; then . "./$_where/tick.sh"; fi
	#if [ -e "./$_whst1/tick.cmd" ]; then . "./$_whst1/tick.cmd"; fi
	#. "./WORLD/GlobalTick.sh"
	#echo "Health: $_health, Health Buffer: $_healthbuffer, Max Health: $_maxhealth"
	#echo "Energy: $_energy, Energy Buffer: $_energybuffer, Max Energy: $_maxenergy"
	#echo "Time: $ttick - $tminute - $thour - $tDay"
	#echo "where: '$_where'"

	#if Sleeping/Skipping Turns, Skip Input
	if [ $_sleep -gt 0 ]; then
		#echo "Skip! $sleep"
		_sleep=$((_sleep - 1))
		. "$_sleepc"
		sleep 0.05
	else
		_sleep=0
		_sleepc=
		#Get Input		#read -rp"> " _act _p1 _p2
		echo -ne "\e[96m"
		read -erp"> " _in
		echo -e "\e[0m"
		
		#echo "$_in"
		if [ "$(echo "$_in" | tr "[:upper:]" "[:lower:]")" = "quit" ]; then
			quitwarn
		elif [ "${_in:-null}" = "null" ]; then
			return
		else
			. ./PRGM/parser/DirectClause.sh
		fi
	fi

}

StartMenu () {
	clear
	. ./PRGM/output/menu/StartMenu.sh
	_act=
	read -rp "Enter Name or Action:" _act
	_act=$(echo $_act | tr "[:upper:]" "[:lower:]")

	case "$_act" in
	q)
		echo "Goodbye."
		pause
		exit;;
		#Stop
	*)
		if [ -e "./DYNAMIC/Player/maccherry/Where" ]; then
			ppath="./DYNAMIC/Player/maccherry"
			pname="maccherry"
			. ./PRGM/player/LoadChar.sh
		else
			echo "./DYNAMIC/Player/$_act/where.txt"
			echo "That character does not exist!"
			echo "Press Enter"
			pause
			StartMenu
		fi;;
	esac
	_act=
	_in=



}

Stop () {
  echo "QUITING, no save."
    echo "Goodbye!  Come back any time!"
}


#___START HERE___#
while true; do
pause
StartMenu
#clear

echo "Welcome, $_name."
read -t 0.1
echo

. ./PRGM/action/data/where.sh
. ./PRGM/action/look.sh

until [ "$_in" = "QUIT" ];
do
	GameTick
done

#Player has Quit,
#Clean up and return to start menu.
Stop
done
