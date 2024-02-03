#!/bin/sh

Base=60

out=0

rand () {
	shuf -e $(seq "$1" "$2") | head -n1
}

case $1 in
1)out=$(rand 8 14);;
2)out=$(rand 3 8);;
3)out=$(( `rand 0 6` - 3 ));;
4)out=$(( `rand 0 7` - 7 ));;
5)out=$(( 0 - `rand 7 13` ));;
6)out=$(( 0 - `rand 12 20` ));;
esac

#echo $out

if [ "$2" = Female ]; then
	out=$(( out - 2 ))
elif [ "$2" = Male ]; then
	out=$(( out + 1 ))
fi

#echo $out

out=$(( Base + out ))
echo "$out"
