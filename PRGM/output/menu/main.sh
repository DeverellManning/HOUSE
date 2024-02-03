#!/bin/bash

ttick=$(< "./WORLD/time")
tminute=$(((ttick / 5)%30 * 2))
thour=$((((ttick / 5) / 30)%24))
tDay=$((((ttick / 5) / 30) / 24))

if [[ ${tminute:=0} -le 9 ]]; then tminute="0$tminute"; fi

if [[ $thour -le 12 ]]; then
	APM=am
elif [[ $thour -gt 12 ]]; then
	APM=pm
elif [[ $thour -gt 24 ]]; then
	echo "Clock Error1!"
fi

if [[ $APM = pm ]]; then thour=$((thour - 12)); fi
if [[ $thour -eq 0 ]]; then thour=12; fi
textraspace=" "
if [[ $thour -ge 10 ]];then textraspace=""; fi
u=\\033[4m\\033[1m
e=\\033[24m\\033[0m
echo "                      ╔══════════════════╗                      "
echo "╭─────────────────────╢THE HOUSE  PROJECT╟─────────────────────╮"
echo "│                     ╚══════════════════╝                v$_gameversion │"
echo "│ The open-world, file-based interactive story.                │"
echo "│                                                              │"
echo "│ It is currently $thour:$tminute $APM in the Eligotextum World.           $textraspace│"
echo "│                                                              │"
echo -e "│ From here, you can ${u}J${e}oin the game as a character, create      │"
echo -e "│ a ${u}N${e}ew character, learn more ${u}A${e}bout this project, read the     │"
echo -e "│ ${u}C${e}hangelog, or ${u}Q${e}uit the game.                                 │"
echo "╰──────────────────────────────────────────────────────────────╯"
echo
echo "Hello, $_username."
echo "Type a letter."
