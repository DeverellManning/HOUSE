#!/bin/bash

#LC-Filter
if [[ "$1" =~ /[Nn]ame\.txt ]];then exit; fi
if [[ "$1" =~ /[Tt]ick ]];then exit; fi
if [[ "$1" =~ /[Vv]eiw ]];then exit; fi
if [[ "$1" =~ /[dD]ir ]];then exit; fi
if [[ "$1" =~ /[rR]oom ]];then exit; fi

if [[ "$1" =~ Container ]];then exit; fi
if [[ "$1" =~ /[Uu]se\. ]];then exit; fi
if [[ "$1" =~ /[Dd]isc\. ]];then exit; fi

if [[ "$1" = "$_where" ]]; then exit; fi
if [[ "$1" = $ppath/Inventory ]]; then exit; fi
if [[ "$1" = $_target ]]; then exit; fi
if [[ "$1" =~ ^$ppath/Clothes/[^/]*$ ]]; then exit; fi

name=$(echo "$1" | grep -o "[^/]*$" -- | sed -e "s/^\.//g" | sed -e "s/\..*$//g")
if [ "$(echo "$1" | grep -o "[^/]*$" -- | cut -c 1)" = "." ];then exit; fi
if [ "$name" = "${_name}" ]; then exit; fi


#LC-Style
type=$(echo "$1" | grep -o "\.[^\.]*$" --)

if [ "$type" = ".door" ];then
echo " ∏ $name";
elif [ "$type" = ".char" ];then
echo " ∆ $name";
else
echo " ~ $name";
fi
