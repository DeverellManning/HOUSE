#!/bin/bash
echo "More Level: ${_more:=0}"

echo -e "Veiw: \n $veiw"

dc=0
i=1
until [[ $dc = $_more ]]; do
	cl=$(echo "$veiw" | head -n$i | tail -n1);
       	if [[ $cl = ... ]]; then 
		dc=$((dc+1)); 
	fi; 
	echo "$dc-$cl";
	i=$((i+1))	
done
cl=$(echo "$veiw" | head -n$i | tail -n1);
until [[ $cl = ... || $i -ge $length ]]; do 
	i=$((i+1))	
	cl=$(echo "$veiw" | head -n$i | tail -n1);
	echo "$i$cl"; 
done
