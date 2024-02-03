#!/bin/bash

if [[ ! -e $ppath/looks/looks.prop ]]; then
	touch "$ppath/looks/looks.prop"
	echo -e "@Looks">>"$ppath/looks/looks.prop"
	echo -e "\`hair-length=$HL\`">>"$ppath/looks/looks.prop"
	echo -e "\`hair-color=$HC\`">>"$ppath/looks/looks.prop"
	echo -e "\`eye-color=$EC\`">>"$ppath/looks/looks.prop"
	echo -e "\`leg-length=$ll\`">>"$ppath/looks/looks.prop"
	echo -e "@End">>"$ppath/looks/looks.prop"
fi