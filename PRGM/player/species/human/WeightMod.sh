#!/bin/sh

Base=130

out=0

rand () {
	shuf -e $(seq "$1" "$2") | head -n1
}

case $1 in
+)out=$(( `rand 5 11` * ( $3 / 4 )));;
0)out=$(( ( `rand 0 5` - 2 ) * ( $3 / 12 )));;
-)out=$(( ( 0 - `rand 2 8` ) * ( $3 / 12 )));;
esac


if [ $2 = Female ]; then
	bt=$(echo " 1.03 * ( $out - $Base ) " | bc)
	if [ $(echo "$bt > 5" | bc) -eq 1 ]; then bt=6; fi
	if [ $(echo "$bt <  5" | bc) -eq 1 ]; then bt=-6; fi
	out=$( echo "$out + $bt" | bc )
fi


out=$(echo "$Base + $out" | bc)
echo "$out"
