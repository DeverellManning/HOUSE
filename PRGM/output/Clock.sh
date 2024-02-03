#!/bin/bash

hour=00
hour=$1

if [[ ${2:-null} = null ]]; then read hour; fi

min=0
min=$2
if [[ ${min:=0} -le 9 ]]; then min="0$min"; fi

if [[ $hour -le 12 ]]; then
	APM=AM
elif [[ $hour -gt 12 ]]; then
	APM=PM
elif [[ $hour -gt 24 ]]; then
	echo "Clock Error1!"
	return
fi

if [[ $APM = PM ]]; then hour=$((hour - 12)); fi
if [[ $hour -eq 0 ]]; then hour=12; fi

decho "$hour:$min"
decho "$APM"


ln1=" ▄▄▄▄▄▄▄▄▄ "
ln2="▐▀ - - - ▀▌"
ln3="▐-       -▌"
ln4="▐-   ♦   -▌"
ln5="▐-       -▌"
ln6="▐▄ - - - ▄▌"
ln7=" █▀▀▀▀▀▀▀█ "
ln8=" █?      █ "
ln9="  ▀▀▀▀▀▀▀  "


case $hour in
1)ln2="▐▀ - - ▄ ▀▌"
  ln3="▐-    /  -▌";;
  
2)ln3="▐-     _─▌▌"
  ln4="▐-   ♦¯  -▌";;
  
3)ln4="▐    ♦═══▌▌";;

4)ln4="▐-   ♦_  -▌"
  ln5="▐-     ¯─▌▌";;
  
5)ln5="▐-    \  -▌"
  ln6="▐▄ - - ▀ ▄▌";;
  
6)ln5="▐-   ║   -▌"
  ln6="▐▄ - ▀ - ▄▌";;
  
7)ln5="▐-  /    -▌"
  ln6="▐▄ ▀ - - ▄▌";;
  
8)ln4="▐-  _♦   -▌"
  ln5="▐▐─¯     -▌";;
  
9)ln4="▐▐═══♦   -▌";;

10)ln3="▐▐─_     -▌"
   ln4="▐-  ¯♦   -▌";;
   
11)ln2="▐▀ ▄ - - ▀▌"
   ln3="▐-  \    -▌";;

12)ln2="▐▀ - ▄ - ▀▌"
   ln3="▐-   ║   -▌";;

*)echo "Clock Error2!"
esac

if [[ $hour -le 9 ]];then ln8=" █$hour:$min $APM█ "; fi
if [[ $hour -ge 10 ]];then ln8=" █$hour:$min$APM█ "; fi


echo "$ln1"
echo "$ln2"
echo "$ln3"
echo "$ln4"
echo "$ln5"
echo "$ln6"
echo "$ln7"
echo "$ln8"
echo "$ln9"
