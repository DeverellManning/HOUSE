#!/bin/bash

#Filters Files
#Not to be sourced

#Usage: echo -e "$FileList" | xargs -n1 ./PRGM/utility/GenericFilter.sh

if [[ "$1" = $_where ]]; then exit; fi
if [[ "$1" = $ppath/Inventory ]]; then exit; fi

if [[ "$1" =~ /[Nn]ame\.txt ]];then exit; fi
if [[ "$1" =~ /[Tt]ick ]];then exit; fi
if [[ "$1" =~ /[Vv]eiw ]];then exit; fi
if [[ "$1" =~ /[dD]ir ]];then exit; fi

echo "$1"
