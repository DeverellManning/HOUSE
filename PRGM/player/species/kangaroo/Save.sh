#!/bin/bash

if [[ ! -e $ppath/looks/looks.prop ]]; then
	touch "$ppath/looks/looks.prop"
	echo -e "@Looks">>"$ppath/looks/looks.prop"
	echo -e "\`hair-length=$HL\`">>"$ppath/looks/looks.prop"
	echo -e "\`hair-color=$HC\`">>"$ppath/looks/looks.prop"
	echo -e "\`eye-color=$EC\`">>"$ppath/looks/looks.prop"
	echo -e "\`leg-length=$ll\`">>"$ppath/looks/looks.prop"
	echo -e "@Farax">>"$ppath/looks/looks.prop"
	echo -e "\`fur-color=$Fur\`">>"$ppath/looks/looks.prop"
	echo -e "\`fur-adj=$FurAdj\`">>"$ppath/looks/looks.prop"
	echo -e "\`tail-length=$TailL\`">>"$ppath/looks/looks.prop"
	echo -e "@End">>"$ppath/looks/looks.prop"
fi