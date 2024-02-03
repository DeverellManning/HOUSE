#!/bin/bash
if [[ ! -e $Item ]]; then
	return
fi
buttons=$(qprop Interface@Interface "$Item")

bc=$(_lineCount "$buttons")

for i in $(seq 1 $bc); do
	cl=$(_getLine "$buttons" $i)
	cl=$(echo "$cl" | sed -e "s/\`//g")
	cname=$(echo "$cl"|sed -e "s/=.*$//")
	#echo $cl
	if [[ $dirobj = $cname ]]; then
		#decho "FOUND"
		Button=$(echo "$cl"|sed -e "s/^.*=//")
	fi
done

echo "Item: $Item"
echo "Button: $Button"

. "$Item" "$Button"
