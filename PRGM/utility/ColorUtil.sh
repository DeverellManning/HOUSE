#!/bin/bash
CUColors="black
	grey
	brown
	pink
	purple
	violet
	olive
	tan
	sandy
	pale-glow
	yellow
	blue
	sea-green
	willow-green
	maroon
	white
	magneta
	magenta
	red
	green
	orange
	tomato
	deep-blue
	moss-green
	egg-white-yellow
	classic
	bread-dough-brown
	ginger
	sandy
	grey
	gray
	teal
"

listcolor () {
	echo "Available Colors:"
	echo "$CUColors"
}
incolor () {
	read -r -p "Pick a Color, 'list' to list known colors: " in
	in=$(echo "$in" | tr "[A-Z]" "[a-z]" | sed -e "s/[ ,+]\+/-/g")
	echo "You said '$in'"
	echo "$CUColors" | grep -iwo "$in" | head -n1 
	if [ "$in" = list ]; then listcolor; incolor "$1"; return
	fi
	if [ "$(echo "$CUColors" | grep -iwo "$in"  | head -n1 )" = "$in" ]; then
		echo "Color Found!"
		export "$1"="$in"
		return
	fi
	echo "We do not have that color yet.  Sorry!"
	incolor "$1"
}
