#!/bin/bash

_ptty="/dev/pts/2"
ppath="./WORLD/CHARACTERS/PLAYERS/arina"
_name="Arina"

until [[ $ctick = END ]]; do
	#Getting Ready
	ctick=
	. "./PRGM/output/message-tick.sh">"$_ptty";
	sleep 0.2
done
