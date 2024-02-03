#!/bin/bash

decho $PWD
confpath=./CONFIG
#Find Config File
if [[ ! -e "$confpath" ]]; then
	confpath=$(find ~/ -iregex ".*HOUSE/CONFIG$")
	if [[ ! -e "$confpath" ]]; then
		_serror "COULD NOT LOCATE CONFIG FILE."
	fi
fi

#Load Config
_conf=$(cat CONFIG)

#Read base path from config
_basepath=$(echo $_conf | jq -r .path)
decho "Basepath: $_basepath"
cd $_basepath


#Check for critical elements
if [[ ! -e "./PRGM" || ! -e "./EXPLORE.sh" ]]; then
	_serror "PRGM FOLDER or EXPLORE.SH MISSING"
fi

decho "$(ls)"



#Read and Evaluate Config File
decho "Loading config..."

#Path to Local World
_c_locworld=$(echo $_conf | jq -r ".local_world")

#Which World? (Online or Local)
_c_useworld=$(echo $_conf | jq  -r ".use_world")

#Can this client become master?
_c_canmaster=$(echo $_conf | jq -r ".can_become_master")

decho "Path to local world: $_c_locworld"
decho "use_world: $_c_useworld"
decho "Can become master (online): $_c_canmaster"

decho "Done loading."



_server_available=false
_worldchoice=online
#Evaluate world choice from config and
#Choose what world to connect to.
case $_c_useworld in
0)decho "0 - Default"
	_worldchoice=symlink;;
1)decho "1 - Using local world."
	_worldchoice=local;;
2)decho "2 - Using Online world if available."
	if $_server_available; then
		_worldchoice=online
	else
		_worldchoice=local
	fi
	;;
3)decho "3 - Using Server world, if unavailable, abort."
	if $_server_available; then
		_worldchoice=online
	else
		_serror "Server is not available, aborting."
	fi
	;;
4)decho "4 - Asking what world to use."
	echo "What world are you connecting to?"
	read -p "(local/online)> " _choice
	if [[ ! $_choice =~ ^(local|online)$ ]]; then
		_serror "Choice not recognized.  Options are local and online. Choices are case-sensitive.  Please try again."
	fi
	_worldchoice=$_choice
	;;
5)decho "5 - Using whatever is already there!"
	_worldchoice=symlink
	;;
esac
_connection=false
if [[ $_worldchoice = symlink ]]; then
	true
fi
#Disconnect Command: umount ./WORLD
#Check for Connection
if [[ -e ./WORLD && -e ./SERVER ]]; then
	decho "Conection Successful!"
	echo "Connected to $_worldchoice world."
	
else
	echo "Connection Unsuccsessful!"
	read -N1
	_serror "Not Connected!"

fi

echo "Press any key"
pause
clear
echo
echo "LOGIN TO HOUSE PROJECT"
echo

#Log in:
_SALT=HP

export _username=
export _userpath=

echo "Player Accounts:"
ls -N1 ./SERVER/USERS | xargs -I "{}" echo " - {}"

echo "Enter username from list:"
read -p"> " name

if [[ ! -e ./SERVER/USERS/${name} ]]; then
	_serror "$name does not exist! Abort!"
fi

echo "Enter Password:"
read -p"> " password

echo "Computing Hash:"

testhash=$(openssl passwd -salt "$_SALT" "$password")

echo "Hash is $testhash"
echo
echo "Loading Account Info:"

hash=$(qprop "hash@User" "./SERVER/USERS/${name}/secrets")
echo "Loaded hash is $hash."

if [[ ! $hash == $testhash ]]; then
	_serror "That is the wrong password. Abort!"
fi

echo "Logged In!"

_userpath=./SERVER/USERS/${name}
_username=${name}

if [[ ! $(grep -xF "$_username" "./SERVER/online") ]]; then
	echo "$_username" >> "./SERVER/online" #New line, on the end
fi









decho "Cleaning Up:"
unset _serror
unset _conf
unset _choice
unset confpath
decho "Done with Startup."
unset decho
