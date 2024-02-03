#!/bin/sh

Base=65

out=0

rand () {
	shuf -e $(seq "$1" "$2") | head -n1
}

case $1 in
1)out=$(rand 9 16);;
2)out=$(rand 4 9);;
3)out=$(( `rand 0 7` - 3 ));;#
4)out=$(( `rand 1 5` - 5 ));;
5)out=$(( 0 - `rand 5 8` ));;
6)out=$(( 0 - `rand 7 12` ));;
esac

#echo $out

if [ "$2" = Female ]; then
	out=$(( out - 2 ))
elif [ "$2" = Male ]; then
	out=$(( out + 2 ))
fi

#echo $out

out=$(( Base + out ))
echo "$out"
