#!/bin/sh

Base=120

out=0

rand () {
	shuf -e $(seq "$1" "$2") | head -n1
}

case $1 in
+)out=$(( `rand 4 8` * ( $3 / 4 )));;
0)out=$(( ( `rand 0 4` - 2 ) * ( $3 / 16 )));;
-)out=$(( ( 0 - `rand 1 6` ) * ( $3 / 16 )));;
esac


if [ $2 = Female ]; then
	bt=$(echo " 1.02 * ( $out - $Base ) " | bc)
	if [ $(echo "$bt > 5" | bc) -eq 1 ]; then bt=6; fi
	if [ $(echo "$bt <  5" | bc) -eq 1 ]; then bt=-6; fi
	out=$( echo "$out + $bt" | bc )
fi


out=$(echo "$Base + $out" | bc)
echo "$out"
