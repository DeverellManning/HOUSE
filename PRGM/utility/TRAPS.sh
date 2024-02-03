#!/bin/bash

#Trap Functions
_Trap_Exit () {
	if $_MASTER; then
		echo -n "" > "./SERVER/players" #Fix.  Remove entry from online.txt
		echo "END">"./SERVER/tick"
	fi
	
	#Remove name from online users list
	echo "$(sed -e "s/$_username//g" ./SERVER/online | grep -vx "^$")" > ./SERVER/online

	sleep 1
	#umount ./WORLD
	#umount ./SERVER
	kill "$_pid_messages"
}


trap "_Trap_Exit" EXIT
