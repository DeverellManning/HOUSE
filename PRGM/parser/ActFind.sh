#!/bin/sh

#This program checks for a 
#command called %_act% in the 
#.\PRGM\SH\ folder.
#If found, it will run it.

#Related to (Windows) CMDfind.cmd

  #echo "-ACTFND-"
  
  #echo "ACTFND act:'$_act' P1:'$_p1' P2:'$_p2'"
  
  lact=`echo $_act | tr 'A-Z' 'a-z'`

  VS=`find "./PRGM/action/" -iname "$lact.sh"`
  #VS="./PRGM/SH/"$lact".sh"
  if [ -e "$VS" ]; then
   . $VS $_p1 $_p2	#Source it
   return
  fi
   
   #echo "Unreconized command! Checking Aliases and Items:"
   #Aliases                   #items                        # $_act $_p1 $_p2 
   . ./PRGM/parser/Alias.sh || . ./PRGM/parser/ItemCheck.sh || \
   echo "$_act $_p1 $_p2">>"./OTHER/UnrecAction.txt"
   
   
   
   
   
   
   
